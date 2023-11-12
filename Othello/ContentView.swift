//
//  ContentView.swift
//  Othello
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: OthelloBoardView()) {
                Text("オセロ開始")
                
                Text("\(othelloController.getVictoryColor())")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
