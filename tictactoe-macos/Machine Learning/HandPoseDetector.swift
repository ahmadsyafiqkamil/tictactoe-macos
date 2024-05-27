//
//  HandPoseDetector.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 25/05/24.
//

import CoreML
import Vision

class HandPoseDetector{
    var labelPredict: String = ""
    
    func detectHand(in sampleBuffer: CMSampleBuffer)  {
        let model = tictactoe_model()
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest.maximumHandCount = 1
        handPoseRequest.revision = VNDetectHumanHandPoseRequestRevision1
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Unable to get image buffer from sample buffer.")
            return
        }
        do {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try handler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else {
                return
            }
            guard let keypointsMultiArray = try? observation.keypointsMultiArray()
            else { return  }
            guard let handposeOutput = try? model.prediction(poses: keypointsMultiArray) else {
                fatalError("Unexpected runtime error.")
            }
            let outputPredict = handposeOutput.label
            //            print("predict \(outpuPredict)")
            DispatchQueue.main.async {
                self.labelPredict = outputPredict
                print("predict \(self.labelPredict)")
            }
        } catch {
            print("Failed to perform hand pose request: \(error.localizedDescription)")
            return
        }
    }
    
    //    func predictHand(poses: MLMultiArray){
    //        
    //        guard let handposeOutput = try? model.prediction(poses: poses) else {
    //            fatalError("Unexpected runtime error.")
    //        }
    //        
    //        var outpuPredict = handposeOutput.label
    //        print("predict \(outpuPredict)")
    //    }
}
