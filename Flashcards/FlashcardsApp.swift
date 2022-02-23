//
//  FlashcardsApp.swift
//  Flashcards
//
//  Created by Nikolai Shiriaev on 23.02.22.
//

import SwiftUI

@main
struct FlashcardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
