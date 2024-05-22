//
//  CameraView.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 22/05/24.
//

import SwiftUI
import Cocoa

struct CameraView: NSViewRepresentable {
    typealias NSViewType = NSView

    func makeNSView(context: Context) -> NSView {
        let nsView = NSView()
        do {
            let manager = try CameraManager(containerView: nsView)
            context.coordinator.cameraManager = manager
            manager.delegate = context.coordinator
            try manager.startSession()
        } catch {
            print("Camera error: \(error.localizedDescription)")
        }
        return nsView
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
        do {
            if let manager = coordinator.cameraManager {
                try manager.stopSession()
            }
        } catch {
            print("Camera error: \(error.localizedDescription)")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, CameraManagerDelegate {
        var cameraManager: CameraManagerProtocol?

        func cameraManager(_ output: CameraCaptureOutput, didOutput sampleBuffer: CameraSampleBuffer, from connection: CameraCaptureConnection) {
            // Handle the camera output here if needed
            print(Date())
        }
    }
}

