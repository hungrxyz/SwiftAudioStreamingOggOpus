//
//  ViewController.swift
//  SwiftAudioStreamingOggOpus
//
//  Created by Zel Marko on 01/07/15.
//  Copyright (c) 2015 Zel Marko. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    var engine = AVAudioEngine()
    var session: AVCaptureSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVCaptureSession()
        
        let devices = AVCaptureDevice.devices().first as! AVCaptureDevice
        println(devices)
        
        let deviceInput = AVCaptureDeviceInput.deviceInputWithDevice(devices, error: nil) as! AVCaptureDeviceInput
        session.addInput(deviceInput)
        println(session)
        
        session.startRunning()
        
        if session.running {
            println("running")
        }
        
//        let input = engine.inputNode
//        let format = input.inputFormatForBus(0)
//   
//        input.installTapOnBus(0, bufferSize: 4096, format: format) { (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
//            println(buffer)
//    
//        }
        
//        var error: NSError?
//        
//        engine.startAndReturnError(&error)
//        
//        if error != nil {
//            println(error?.localizedDescription)
//        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        println(sampleBuffer)
        println("bull")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

