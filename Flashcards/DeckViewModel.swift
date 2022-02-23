//
//  DeckViewModel.swift
//  Flashcards
//
//  Created by Nikolai Shiriaev on 23.02.22.
//

import SwiftUI

class DeckViewModel: ObservableObject {
    
    private static let deckSource = [
        "to celebrate": "feiern",
        "to explain": "erklären",
        "yellow": "gelb",
        "the corner\nthe triangle": "die Ecke\ndas Dreieck",
        "the teacher\n(m & f)": "der Lehrer\ndie Lehrerin",
        "How much": "Wie viel",
        "the event/activity" : "die Veranstaltung",
        "slow": "langsam",
        "easy/light": "leicht",
        "busy": "beschäftigt",
        "difficult/heavy":"schwer",
        "bad":"schlecht",
        "the bacon": "der Speck",
        "the knife": "das Messer"
        
    ]
    @Published private var deckModel = DeckModel(name: "Test Deck", QandADict: deckSource)
    
    var name: String {
        deckModel.name
    }
    
    var deck: Array<DeckModel.Card> {
        deckModel.deck
    }
    
    // MARK: - Intents
    func flip (_ card: DeckModel.Card){
        deckModel.flip(card)
    }
    
    func correct(_ cardID: Int){
        deckModel.correct(cardID)
    }
    func incorrect(_ cardID: Int){
        deckModel.incorrect(cardID)
    }

    func correct(_ card: DeckModel.Card){
        deckModel.correct(card)
    }
    func incorrect(_ card: DeckModel.Card){
        deckModel.incorrect(card)
    }

}



