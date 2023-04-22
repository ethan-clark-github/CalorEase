import SwiftUI
import CoreData

struct WatchFoodListView: View {
    @ObservedObject var connectivityViewModel: ConnectivityViewModel
    @State private var foodList: [FoodModel] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(Int(totalCaloriesToday())) KCal (Today)")
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            List {
                ForEach(foodList, id: \.id) { food in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(food.name)
                            .bold()
                        Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.red)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("CalorEase")
        .onReceive(connectivityViewModel.$receivedFoodList, perform: { value in
            foodList = value
        })
    }
    
    private func totalCaloriesToday() -> Double {
        var caloriesToday: Double = 0
        for item in foodList {
            if Calendar.current.isDateInToday(item.date) {
                caloriesToday += item.calories
            }
        }
        return caloriesToday
    }
}

struct WatchFoodListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchFoodListView(connectivityViewModel: ConnectivityViewModel.shared)
    }
}






