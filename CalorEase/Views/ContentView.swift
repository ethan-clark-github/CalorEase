import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>

    @State private var showingAddView = false
    @ObservedObject private var connectivityViewModel = ConnectivityViewModel.shared

    private func setupDayChangeDeletion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            let now = Date()
            if !Calendar.current.isDateInToday(now) {
                DataController().deleteAllFoods(context: managedObjContext)
            }
            setupDayChangeDeletion()
        }
    }

    private func sendDataToWatch() {
        let foodModelList: [FoodModel] = food.map { food in
            FoodModel(name: food.name!, calories: food.calories, date: food.date!)
        }
        connectivityViewModel.sendFoodData(foodList: foodModelList)
    }

    
    private func calcTimeSince(date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }


    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) KCal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(food) { food in
                        NavigationLink(destination: EditFoodView(connectivityViewModel: ConnectivityViewModel.shared, food: food)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(food.name!)
                                        .bold()
                                    Text("\(Int(food.calories)) calories")
                                        .foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date: food.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("CalorEase")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView(connectivityViewModel: connectivityViewModel)
            }
        }
        .navigationViewStyle(.stack)
        .onAppear(perform: setupDayChangeDeletion)
    }

    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
        sendDataToWatch()
    }

    private func totalCaloriesToday() -> Double {
        var caloriesToday: Double = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!) {
                caloriesToday += item.calories
            }
        }
        return caloriesToday
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


