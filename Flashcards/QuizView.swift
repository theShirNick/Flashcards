//
//  QuizView.swift
//  Flashcards
//
//  Created by Nikolai Shiriaev on 23.02.22.
//

import SwiftUI
import CoreData

// MARK: - QuizView
struct QuizView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
//    init(vm: DeckViewModel)
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Card.cardId, ascending: true)],
//        animation: .default)
//    private var CDcards: FetchedResults<Card>
    
    @EnvironmentObject var deckOfCardsViewModel: DeckOfCardsViewModel
    @State var currentCard: Int = 0
    var body: some View {
        VStack{
            Text("DECK'S NAME HERE").font(.title)
            CardLine()
        }
    }

    
    // MARK: - CardLine
    struct CardLine: View {
        
        @EnvironmentObject var deckOfCardsViewModel: DeckOfCardsViewModel
        @State private var selectedIidex: Int32 = 0
        var body: some View {
            TabView(selection: $selectedIidex) {
                ForEach(deckOfCardsViewModel.savedCards) { card in
                    CardView(card: card).tag(card.cardId)
                }
            }.tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .toolbar(content: QuizToolbar)
        }
        
        
        // MARK: - Control Buttons
        func QuizToolbar() -> some ToolbarContent {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {deckOfCardsViewModel.incorrect(selectedIidex)}){
                    Label("", systemImage: "x.circle")
                        .font(.largeTitle)
                }.accentColor(Color(.systemRed))

                Spacer()
                Button(action: {deckOfCardsViewModel.resetWithTestCards()}){
                    Label("", systemImage: "restart.circle")
                        .font(.largeTitle)
                }.accentColor(Color(.systemGray))
                Spacer()

                Button(action: {deckOfCardsViewModel.correct(selectedIidex)}){
                    Label("", systemImage: "checkmark.circle")
                        .font(.largeTitle)
                }.accentColor(Color(.systemGreen))

    
            }
        }
    }
    
    // MARK: - CardView
    struct CardView: View, Animatable {
        @EnvironmentObject var deckOfCardsViewModel: DeckOfCardsViewModel
        let card: Card
        var rotationAngle:  Double
        init(card: Card) {
            self.card = card
            rotationAngle =  card.isQSide ?  0.0 : 180.0
        }
        var animatableData: Double {
            get{
                rotationAngle
            }
            set{
                rotationAngle = newValue
            }
        }
              
        var body: some View {
            ZStack{
                let shape = RoundedRectangle(cornerRadius: Consts.cornerRadius)
                shape.fill().foregroundColor(.secondary)
                if card.isCorrect == nil {
                    shape.strokeBorder(lineWidth: Consts.strokeBorder).foregroundColor(.gray)
                }
                else if card.isCorrect == true {
                    shape.strokeBorder(lineWidth: Consts.strokeBorder).foregroundColor(.green)
                }
                else {
                    shape.strokeBorder(lineWidth: Consts.strokeBorder).foregroundColor(.red)
                }
                
                if rotationAngle < 90 {
                    Text(card.qSide ?? "...").font(.title2).padding()
                    
                } else{
                    Text(card.aSide ?? "...").font(.title2).padding().rotation3DEffect(Angle.degrees(-180), axis: (x: 0, y: 1, z: 0))
                }
            }
            .padding().padding().padding()
            .rotation3DEffect(Angle.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
            .onTapGesture {
                withAnimation(.easeInOut(duration: 1.0)){
                    deckOfCardsViewModel.flip(card)
                    
                }
            }
        }
    }
    
    
    
//    struct QuizView_Previews: PreviewProvider {
//        static var previews: some View {
//            let previewVM = DeckOfCardsViewModel()
//            return QuizView()
//                .environmentObject(previewVM)
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//                .previewInterfaceOrientation(.portrait)
//                .preferredColorScheme(.dark)
//        }
//    }
}
