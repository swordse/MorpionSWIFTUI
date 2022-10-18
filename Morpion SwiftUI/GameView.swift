//
//  GameView.swift
//  Morpion SwiftUI
//
//  Created by Raphaël Goupille on 24/05/2022.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    @State private var tap = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Joueur:")
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { index in
                        ZStack {
                            CercleGameView(geometry: geometry)
                            PlayerMark(systemeImage: viewModel.moves[index]?.indicator ?? "", markColor: viewModel.moves[index]?.player == .human ? .blue : .red)
                                
//                                .opacity(viewModel.moves[index]?.indicator == "" ? 0: 1)
//                                .animation(.spring(response: 0.4, dampingFraction: 0.6))
                        }
                        .onTapGesture{
                            withAnimation(Animation.easeIn(duration: 0.5)) {
                            viewModel.processPlayerMove(for: index)
                            }
                        }
                        
                    }
                }
                .background(.black)
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.resetGame()
                }))
            }
        }
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct CercleGameView: View {
    
    let geometry: GeometryProxy

    var body: some View {
        Rectangle()
            .foregroundColor(.white)
//            .opacity(0.8)
            .frame(width: geometry.size.width/3 - 13, height: geometry.size.width/3 - 10)
    }
}

struct PlayerMark: View {
    
    let systemeImage: String
    let markColor: Color
    
    var body: some View {
        Image(systemName: systemeImage)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(markColor)
    
    }
}
