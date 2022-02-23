//
//  DeckViewModel.swift
//  Flashcards
//
//  Created by Nikolai Shiriaev on 23.02.22.
//

import SwiftUI
import CoreData

class DeckOfCardsViewModel: ObservableObject {
    
//    static let shared = DeckOfCardsViewModel()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Flashcards")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Core Data unresolved error \(error), \(error.userInfo)")
            }
        })
        
        if savedCards.isEmpty {
            resetWithTestCards()
        }

    }
    
//    static var preview: DeckOfCardsViewModel = {
//        let result = DeckOfCardsViewModel(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Card(context: viewContext)
////            newItem.timestamp = Date()
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Core Data saving - Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
    
    private let testCardsSource = [
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
//    @Published private var deckModel = DeckModel(name: "Test Deck", QandADict: deckSource)
    
    
    @Published var savedCards: [Card] = []
    

    
//    var name: String {
//        deckModel.name
//    }
    
//    var deck: Array<DeckModel.Card> {
//        deckModel.deck
//    }
    
    func saveData(){
        do {
            try container.viewContext.save()
            
            fetchCards()
        } catch {
            print("Error while saving Core Dtata. \(error)")
        }
    }
    // MARK: - Intents
    func fetchCards() {
        let request = NSFetchRequest<Card>(entityName: "Card")
        do {
            savedCards = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching cards. \(error)")
        }
    }
    
    func addCard(id: Int, qSide: String, aSide: String, withSaving: Bool = true) {
        let newCard = Card(context: container.viewContext)
        newCard.cardId = Int32(id)
        newCard.isCorrect = nil // potential problem due to nullable scalar type.
        newCard.isQSide = true
//        newCard.deck = nil // Fix later
        newCard.aSide = aSide
        newCard.qSide = qSide
        if withSaving {
            saveData()
        }
    }
    
    func resetWithTestCards() {
        for savedCard in savedCards {
            container.viewContext.delete(savedCard)
        }
        var i = 0
        for (q, a) in testCardsSource {
            addCard(id: i, qSide: q, aSide: a, withSaving: true)
            i += 1
        }
        saveData()
    }
    
    func flip(_ card: Card) {
        card.isQSide = !card.isQSide
        saveData()
    }
    
//    func correct(_ cardID: Int){
//        deckModel.correct(cardID)
//    }
//    func incorrect(_ cardID: Int){
//        deckModel.incorrect(cardID)
//    }

    func correct(_ cardId: Int32){
        if let foundCard = savedCards.first(where:{$0.cardId==cardId}){
            foundCard.isCorrect = true
            saveData()
        }
    }
    func incorrect(_ cardId: Int32){
        if let foundCard = savedCards.first(where:{$0.cardId==cardId}){
            foundCard.isCorrect = false
            saveData()
        }
    }
    
}



