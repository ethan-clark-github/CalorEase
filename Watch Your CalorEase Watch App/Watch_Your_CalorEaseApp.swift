//
//  Watch_Your_CalorEaseApp.swift
//  Watch Your CalorEase Watch App
//
//  Created by ethan clark on 3/17/23.
//

//import SwiftUI
//
//@main
//struct Watch_Your_CalorEase_Watch_AppApp: App {
//
//    @ObservedObject private var connectivityViewModel = ConnectivityViewModel.shared
//
//        @SceneBuilder var body: some Scene {
//            WindowGroup {
//                NavigationView {
//                    ContentView()
//                }
//                .environmentObject(connectivityViewModel)
//            }
//        }
//    }

import SwiftUI

@main
struct Watch_Your_CalorEaseApp: App {
    @StateObject var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}



