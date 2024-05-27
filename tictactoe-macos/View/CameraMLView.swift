//
//  CameraML.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 26/05/24.
//

import SwiftUI

struct CameraMLView: View {
    @StateObject private var coordinator = CameraView.Coordinator()
    var body: some View {
        ZStack {
            CameraView()
                .environmentObject(coordinator)
                .onAppear {
                    print("Camera View appeared.")
                }
            
            HStack {
                Text("Detected People: \(coordinator.detectedPeopleCount)")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding()
                
                
                Text("Detected Hand Pose: \(coordinator.detectedHandPose)")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding()
                Spacer()
                
            }

        }
    }
}

#Preview {
    CameraMLView()
}
