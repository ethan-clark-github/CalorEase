import SwiftUI

struct AddFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjContext
    @ObservedObject var connectivityViewModel: ConnectivityViewModel

    @State private var foodName: String = ""
    @State private var calories: String = ""

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Add Food")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                Text("Food Name")
                TextField("Enter Food Name", text: $foodName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
                Text("Calories")
                TextField("Enter Calories", text: $calories)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
            }
            .padding()

            Button("Save") {
                guard let calories = Double(calories) else { return }
                DataController().addFood(name: foodName, calories: calories, context: managedObjContext)
                sendDataToWatch()
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
            Spacer()
        }
        .navigationTitle("Add Food")
    }

    private func sendDataToWatch() {
        let foodList = [FoodModel(name: foodName, calories: Double(calories) ?? 0.0, date: Date())]
        connectivityViewModel.sendFoodData(foodList: foodList)
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView(connectivityViewModel: ConnectivityViewModel.shared)
    }
}




