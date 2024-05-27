//
//  CameraManager.swift
//  tictactoe-macos
//
//  Created by Ahmad Syafiq Kamil on 21/05/24.
//

import AVFoundation
import Cocoa

enum CameraError: LocalizedError {
  case cannotDetectCameraDevice
  case cannotAddInput
  case previewLayerConnectionError
  case cannotAddOutput
  case videoSessionNil
  
  var localizedDescription: String {
    switch self {
    case .cannotDetectCameraDevice: return "Cannot detect camera device"
    case .cannotAddInput: return "Cannot add camera input"
    case .previewLayerConnectionError: return "Preview layer connection error"
    case .cannotAddOutput: return "Cannot add video output"
    case .videoSessionNil: return "Camera video session is nil"
    }
  }
}

typealias CameraCaptureOutput = AVCaptureOutput
typealias CameraSampleBuffer = CMSampleBuffer
typealias CameraCaptureConnection = AVCaptureConnection

protocol CameraManagerDelegate: AnyObject {
  func cameraManager(_ output: CameraCaptureOutput, didOutput sampleBuffer: CameraSampleBuffer, from connection: CameraCaptureConnection)
}

protocol CameraManagerProtocol: AnyObject {
  var delegate: CameraManagerDelegate? { get set }
  
  func startSession() throws
  func stopSession() throws
}

final class CameraManager: NSObject, CameraManagerProtocol {
  
  private var previewLayer: AVCaptureVideoPreviewLayer!
  private var videoSession: AVCaptureSession!
  private var cameraDevice: AVCaptureDevice!
  
  private let cameraQueue: DispatchQueue
  
  private let containerView: NSView
  
  weak var delegate: CameraManagerDelegate?
  
  init(containerView: NSView) throws {
    self.containerView = containerView
    cameraQueue = DispatchQueue(label: "sample buffer delegate", attributes: [])
    
    super.init()
    
    try prepareCamera()
  }
  
  deinit {
    previewLayer = nil
    videoSession = nil
    cameraDevice = nil
  }
  
    private func prepareCamera() throws {
        videoSession = AVCaptureSession()
        videoSession.sessionPreset = AVCaptureSession.Preset.photo
        previewLayer = AVCaptureVideoPreviewLayer(session: videoSession)
        previewLayer.videoGravity = .resizeAspectFill

        // Updated to use AVCaptureDevice.DiscoverySession
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = discoverySession.devices

        cameraDevice = devices.first

        if let cameraDevice = cameraDevice {
            do {
                let input = try AVCaptureDeviceInput(device: cameraDevice)
                if videoSession.canAddInput(input) {
                    videoSession.addInput(input)
                } else {
                    throw CameraError.cannotAddInput
                }

                if let connection = previewLayer.connection, connection.isVideoMirroringSupported {
                    connection.automaticallyAdjustsVideoMirroring = false
                    connection.isVideoMirrored = true
                } else {
                    throw CameraError.previewLayerConnectionError
                }

                previewLayer.frame = containerView.bounds
                containerView.layer = previewLayer
                containerView.wantsLayer = true

            } catch {
                throw CameraError.cannotDetectCameraDevice
            }
        } else {
            throw CameraError.cannotDetectCameraDevice
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: cameraQueue)
        if videoSession.canAddOutput(videoOutput) {
            videoSession.addOutput(videoOutput)
        } else {
            throw CameraError.cannotAddOutput
        }
    }

  
  func startSession() throws {
    if let videoSession = videoSession {
      if !videoSession.isRunning {
        cameraQueue.async {
          videoSession.startRunning()
        }
      }
    } else {
      throw CameraError.videoSessionNil
    }
  }
  
  func stopSession() throws {
    if let videoSession = videoSession {
      if videoSession.isRunning {
        cameraQueue.async {
          videoSession.stopRunning()
        }
      }
    } else {
      throw CameraError.videoSessionNil
    }
  }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    delegate?.cameraManager(output, didOutput: sampleBuffer, from: connection)
  }
}
