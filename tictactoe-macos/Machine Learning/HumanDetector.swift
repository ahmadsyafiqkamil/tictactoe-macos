//
//  HumanDetector.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 23/05/24.
//

import SwiftUI
import Cocoa
import Vision
import AVFoundation

// Asumsi CameraManagerProtocol, CameraCaptureOutput, dan CameraSampleBuffer sudah didefinisikan

class HumanDetector {
    var peopleCount: Int = 0
    var detectedRectangle: [CGRect] = []

    func detectHuman(in sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Unable to get image buffer from sample buffer.")
            return
        }
        
        let request = VNDetectHumanRectanglesRequest { [weak self] request, error in
            if let error = error {
                print("Error detecting humans: \(error.localizedDescription)")
                return
            }
            
            guard let observations = request.results as? [VNHumanObservation] else {
                print("No human observation results.")
                return
            }
            
            DispatchQueue.main.async {
                self?.peopleCount = observations.count
                self?.detectedRectangle = observations.map { $0.boundingBox }
                
//                print("Detected people count: \(self?.peopleCount ?? 0)")
            }
        }
        
        request.upperBodyOnly = false
        
        do {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try handler.perform([request])
        } catch {
            print("Failed to perform request: \(error.localizedDescription)")
        }
    }
}

