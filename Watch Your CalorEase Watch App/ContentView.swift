//
//  ContentView.swift
//  Watch Your CalorEase Watch App
//
//  Created by ethan clark on 3/17/23.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("cal!")
//        }
//        .padding()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI
import CoreData
import Foundation


struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: FoodModel.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodModel.date, ascending: false)]
    ) var foods: FetchedResults<FoodModel>

    @EnvironmentObject var connectivityViewModel: ConnectivityViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(foods) { (food: FoodModel) in
                //ForEach(food) { food in
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(food.name ?? "")
                                .bold()
                            Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.red)
                        }
                        Spacer()
                        Text(calcTimeSince(date: food.date ?? Date()))
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
            }
            .navigationTitle("CalorEase")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


