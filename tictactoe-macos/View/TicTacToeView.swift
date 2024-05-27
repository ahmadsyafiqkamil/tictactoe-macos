//
//  TicTacToeView.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 26/05/24.
//

import SwiftUI


enum Player: String {
    case x = "X"
    case o = "O"
}

struct TicTacToeView: View {
    @State private var currentPlayer: Player = .x
    @State private var cells: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    var body: some View {
        
        
        VStack {
            ForEach(0..<3) { row in
                HStack(spacing: 20) {
                    ForEach(0..<3) { column in
                        Button(action: {
                            if cells[row][column] == nil {
                                cells[row][column] = currentPlayer
                                currentPlayer = currentPlayer == .x ? .o : .x
                                
                                print(row,column)
                            }
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(currectColor(row, column))
                                    .frame(width: 80, height: 80)
                                    .shadow(radius: 5)
                                Text(cells[row][column]?.rawValue ?? "")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        })
                        .padding()
                    }
                }
            }
            Button{
                print("reset")
            }label: {
                Text("Reset")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width: 260, height: 50)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
    
    func currectColor(_ row:Int,_ column:Int)->Color{
        if cells[row][column] == .x {
            return .red
        }else if cells[row][column] == .o {
            return .blue
        }
        return .gray
    }

}


#Preview {
    TicTacToeView()
}
