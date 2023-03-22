//
//  jackal_appleApp.swift
//  jackal-apple
//
//  Created by Yuhei Yamauchi on 2023/03/22.
//

import SwiftUI

@main
struct jackal_appleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
