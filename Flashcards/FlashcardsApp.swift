//
//  FlashcardsApp.swift
//  Flashcards
//
//  Created by Nikolai Shiriaev on 23.02.22.
//

import SwiftUI

@main
struct FlashcardsApp: App {
//    let deckOfCardsViewModel = DeckOfCardsViewModel()
    @StateObject var deckOfCardsViewModel = DeckOfCardsViewModel()

    var body: some Scene {
        WindowGroup {
            QuizView()
                .environmentObject(deckOfCardsViewModel)
                .environment(\.managedObjectContext, deckOfCardsViewModel.container.viewContext)
        }
    }
}
