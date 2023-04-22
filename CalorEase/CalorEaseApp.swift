//
//  CalorEaseApp.swift
//  CalorEase
//
//  Created by ethan clark on 3/15/23.
//

import SwiftUI
import WatchConnectivity


@main


struct CalorEaseApp: App {
    @StateObject private var dataController = DataController()
    @ObservedObject private var connectivityViewModel = ConnectivityViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(connectivityViewModel)
                .onAppear(perform: {
                            if WCSession.default.isReachable {
                                WCSession.default.delegate = connectivityViewModel
                                WCSession.default.activate()
                            }
                        })
        }
    }
}
