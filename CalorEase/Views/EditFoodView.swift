import SwiftUI

struct EditFoodView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var connectivityViewModel: ConnectivityViewModel
    @ObservedObject var food: Food

    @State private var name: String = ""
    @State private var calories: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Name")) {
                    TextField("Enter food name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            name = food.name ?? ""
                        }
                }
                Section(header: Text("Calories")) {
                    TextField("Enter calories", text: $calories)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onAppear {
                            calories = String(format: "%.0f", food.calories)
                        }
                }
                Section {
                    Button(action: updateFood) {
                        Text("Update Food")
                    }
                }
                Section {
                    Button(action: deleteFood) {
                        Text("Delete Food")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Edit Food")
        }
    }

    private func updateFood() {
        guard let calories = Double(calories) else { return }
        DataController().editFood(food: food, name: name, calories: calories, context: managedObjectContext)
        presentationMode.wrappedValue.dismiss()
        connectivityViewModel.sendDataToWatch()
    }

    private func deleteFood() {
        withAnimation {
            managedObjectContext.delete(food)
            DataController().save(context: managedObjectContext)
            presentationMode.wrappedValue.dismiss()
            connectivityViewModel.sendDataToWatch()
        }
    }
}

struct EditFoodView_Previews: PreviewProvider {
    static var previews: some View {
        EditFoodView(connectivityViewModel: ConnectivityViewModel.shared, food: Food())
    }
}



