//
//  DeckModel.swift
//  Flashcards
//
//  Created by Nikolai Shiriaev on 23.02.22.
//

import Foundation

struct DeckModel {
    private(set) var name: String
    private(set) var deck: [Card]
    
    init(name: String, QandADict: Dictionary<String, String>){
        self.name = name
        deck = []
        var idCounter = 0
        for (q, a) in QandADict{
            deck.append(Card(QSide: q, ASide: a, id: idCounter))
            idCounter += 1
        }
    }

    struct Card: Identifiable, Hashable {
        var isQSide = true
        var QSide: String
        var ASide: String
        var isCorrect: Bool?
        var id: Int
    }
    
    mutating func flip(_ card: Card){
        if let i = deck.firstIndex(where:{$0.id==card.id }) {
            deck[i].isQSide = !deck[i].isQSide
        }
    }
    
    mutating func correct(_ cardID: Int){
        if let i = deck.firstIndex(where:{$0.id==cardID }) {
            deck[i].isCorrect = true
        }
    }
    mutating func incorrect(_ cardID: Int){
        if let i = deck.firstIndex(where:{$0.id==cardID }) {
            deck[i].isCorrect = false
        }
    }
    mutating func correct(_ card: Card){
        if let i = deck.firstIndex(where:{$0.id==card.id }) {
            deck[i].isCorrect = true
        }
    }
    mutating func incorrect(_ card: Card){
        if let i = deck.firstIndex(where:{$0.id==card.id }) {
            deck[i].isCorrect = false
        }
    }
}


