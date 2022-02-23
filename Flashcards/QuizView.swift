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
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
    
    @EnvironmentObject var deckViewModel: DeckViewModel
    @State var currentCard: Int = 0
    var body: some View {
        VStack{
            Text(deckViewModel.name).font(.title)
            CardLine()
        }
    }

    
    // MARK: - CardLine
    struct CardLine: View {
        
        @EnvironmentObject var deckViewModel: DeckViewModel
        @State private var selectedIidex = 0
        var body: some View {
            TabView(selection: $selectedIidex){
                ForEach(deckViewModel.deck) { card in
                    CardView(card: card, isQSide: card.isQSide).tag(card.id)
                }
            }.tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .toolbar(content: QuizToolbar)
        }
        
        // MARK: - Control Buttons
        func QuizToolbar() -> some ToolbarContent {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {deckViewModel.incorrect(selectedIidex)}){
                    Label("", systemImage: "x.circle")
                        .font(.largeTitle)
                }.accentColor(Color(.systemRed))
                
                Spacer()
                
                Button(action: {deckViewModel.correct(selectedIidex)}){
                    Label("", systemImage: "checkmark.circle")
                        .font(.largeTitle)
                }.accentColor(Color(.systemGreen))
    
            }
        }
    }
    
    // MARK: - CardView
    struct CardView: View, Animatable {
        @EnvironmentObject var deckViewModel: DeckViewModel
        let card: DeckModel.Card
        var rotationAngle:  Double
        init(card: DeckModel.Card, isQSide: Bool) {
            self.card = card
            rotationAngle =  isQSide ?  0.0 : 180.0
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
                    Text(card.QSide).font(.title2).padding()
                } else{
                    Text(card.ASide).font(.title2).padding().rotation3DEffect(Angle.degrees(-180), axis: (x: 0, y: 1, z: 0))
                }
            }
            .padding().padding().padding()
            .rotation3DEffect(Angle.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
            .onTapGesture {
                withAnimation(.easeInOut(duration: 5.0)){
                    deckViewModel.flip(card)
                    
                }
            }
        }
    }
    
    
    
    struct QuizView_Previews: PreviewProvider {
        static var previews: some View {
            let previewVM = DeckViewModel()
            return QuizView()
                .environmentObject(previewVM)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewInterfaceOrientation(.portrait)
                .preferredColorScheme(.dark)
        }
    }
}
