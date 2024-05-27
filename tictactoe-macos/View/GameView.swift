//
//  GameView.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 26/05/24.
//

import SwiftUI




struct GameView: View {
    var body: some View{
        HStack{
            CameraMLView()
            Spacer()
            TicTacToeView()
        }
        
    }
}

#Preview {
    GameView()
}
