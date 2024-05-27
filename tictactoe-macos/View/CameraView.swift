//
//  CameraView.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 22/05/24.
//

import SwiftUI
import Cocoa
import Vision
import AVFoundation  // Pastikan untuk mengimpor AVFoundation jika CameraManager membutuhkannya

struct CameraView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    typealias NSViewType = NSView  // Ganti dengan subclass yang spesifik jika menggunakan tipe khusus

    @EnvironmentObject var coordinator: Coordinator

    // Membuat NSView untuk representasi
    func makeNSView(context: Context) -> NSViewType {
        let view = NSView()  // Atau subclass spesifik dari NSView
        do {
            let manager = try CameraManager(containerView: view)
            self.coordinator.cameraManager = manager
            manager.delegate = self.coordinator
            try manager.startSession()
        } catch {
            print("Camera error: \(error.localizedDescription)")
        }
        return view
    }

    // Update NSView saat terjadi perubahan data
    func updateNSView(_ nsView: NSViewType, context: Context) {
        // Update view jika diperlukan
    }

    // Membersihkan atau menghentikan sesi saat view dibongkar
    static func dismantleNSView(_ nsView: NSViewType, coordinator: Coordinator) {
        do {
            if let manager = coordinator.cameraManager {
                try manager.stopSession()
            }
        } catch {
            print("Camera error: \(error.localizedDescription)")
        }
    }
}

extension CameraView {
    class Coordinator: NSObject, CameraManagerDelegate, ObservableObject {
        var cameraManager: CameraManagerProtocol?
        private let humanDetector = HumanDetector()
        private let handPoseDetector = HandPoseDetector()
        
        @Published var detectedPeopleCount: Int = 0
        @Published var detectedRectangles: [CGRect] = []
        @Published var detectedHandPose: String = ""

        func cameraManager(_ output: CameraCaptureOutput, didOutput sampleBuffer: CameraSampleBuffer, from connection: CameraCaptureConnection) {
            guard let sampleBuffer = sampleBuffer as? CMSampleBuffer else {
                print("Failed to convert CameraSampleBuffer to CMSampleBuffer.")
                return
            }

            humanDetector.detectHuman(in: sampleBuffer)
            handPoseDetector.detectHand(in: sampleBuffer)
            
            DispatchQueue.main.async {
                self.detectedPeopleCount = self.humanDetector.peopleCount
                self.detectedRectangles = self.humanDetector.detectedRectangle
                self.detectedHandPose = self.handPoseDetector.labelPredict
            }
            
            print("Updated detectedPeopleCount: \(self.detectedPeopleCount)")
        }
    }
}







