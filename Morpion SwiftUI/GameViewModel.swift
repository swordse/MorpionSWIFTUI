//
//  GameViewModel.swift
//  Morpion SwiftUI
//
//  Created by Raphaël Goupille on 25/05/2022.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for index: Int) {
        
            if isSquareOccupied(in: moves, forIndex: index) {
                return
            }
        withAnimation(Animation.easeIn(duration: 0.5)) {
            moves[index] = Move(player: .human, boardIndex: index)
        }
            
            if checkWinCondition(for: .human, in: moves) {
                alertItem = AlertContext.humainWin
                return
            }
            
            if checkForDraw(in: moves) { alertItem = AlertContext.draw
                return
            }
            
            isGameboardDisabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                let computerPosition = determineComputerMovePosition(in: moves)
                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                isGameboardDisabled = false
                
                if checkWinCondition(for: .computer, in: moves) {
                    alertItem = AlertContext.computerWin
                    return
                }
                
                if checkForDraw(in: moves) { alertItem = AlertContext.draw
                    return
                }
                
            }
        
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains { move in
            move?.boardIndex == index
        }
    }
    
    func determineComputerMovePosition(in move: [Move?]) -> Int {
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap { $0 }.filter{ $0.player == .computer }
        let computerPositions = Set(computerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                if !isSquareOccupied(in: moves, forIndex: winPositions.first!) {
                    return winPositions.first!
                }
            }
        }
        
        let playerMoves = moves.compactMap { $0 }.filter{ $0.player == .human }
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(playerPositions)
            if winPositions.count == 1 {
                if !isSquareOccupied(in: moves, forIndex: winPositions.first!) {
                    return winPositions.first!
                }
            }
        }
        let centerIndex = 4
        if !isSquareOccupied(in: moves, forIndex: centerIndex) {
            return centerIndex
        }
        
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}


