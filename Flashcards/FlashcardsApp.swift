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
    @StateObject var deckViewModel = DeckViewModel()

    var body: some Scene {
        WindowGroup {
            QuizView()
                .environmentObject(deckViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
