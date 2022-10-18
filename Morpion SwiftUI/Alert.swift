//
//  Alert.swift
//  Morpion SwiftUI
//
//  Created by Raphaël Goupille on 25/05/2022.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
    
}

struct AlertContext {
    
    static let humainWin = AlertItem(title: Text("You win"), message: Text("Great job"), buttonTitle: Text("New Game"))
    
    static let computerWin = AlertItem(title: Text("You lost"), message: Text("Try again"), buttonTitle: Text("New Game"))
    
    static let draw = AlertItem(title: Text("Draw!"), message: Text("Try again"), buttonTitle: Text("New Game"))
    
}
