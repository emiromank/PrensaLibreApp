//
//  PrensaLApp.swift
//  PrensaL
//
//  Created by emilianoramon on 14/04/24.
//

import SwiftUI

@main
struct PrensaLApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
