//
//  ContentView.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 21/05/24.
//

import SwiftUI

struct ContentView: View {
    private var cameraManager: CameraManagerProtocol!
    var body: some View {
        VStack {
            CameraView()
                .frame(width: 640, height: 480)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
