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
    
//    var engine = AVAudioEngine()
    var session: AVCaptureSession!
    var deviceInput: AVCaptureDeviceInput!
    var output: AVCaptureAudioDataOutput!
    var sessionQueue: dispatch_queue_t!
    var encoder: CSIOpusEncoder!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupEncoder()
            }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        session = AVCaptureSession()
        
        let devices = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        println(devices)
        
        var deviceInput = AVCaptureDeviceInput.deviceInputWithDevice(devices, error: nil) as! AVCaptureDeviceInput
        output = AVCaptureAudioDataOutput()
        sessionQueue = dispatch_queue_create("Callback", DISPATCH_QUEUE_SERIAL)
        
        session.beginConfiguration()
        session.addInput(deviceInput)
        output.setSampleBufferDelegate(self, queue: sessionQueue)
        session.addOutput(output)
        println(session)
        session.commitConfiguration()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "printCaptureError:", name: AVCaptureSessionRuntimeErrorNotification, object: nil)
        notificationCenter.addObserver(self, selector: "printCaptureStart", name: AVCaptureSessionDidStartRunningNotification, object: nil)
        notificationCenter.addObserver(self, selector: "printCaptureStop", name: AVCaptureSessionDidStopRunningNotification, object: nil)

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
    @IBAction func run(sender: AnyObject) {
        session.startRunning()
        
        if session.running {
            println("running")
        }

    }
    @IBAction func stop(sender: AnyObject) {
        session.stopRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        println(session.running)
        goEncodeForMe(sampleBuffer)
    }
    
    func goEncodeForMe(buffer: CMSampleBuffer) {
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            let encodedSamples = self.encoder.encodeSample(buffer)
//            println(encodedSamples)
//        })
        
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            let encodedSamples = self.encoder.encodeSample(buffer)
            println(encodedSamples)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
            })
        })
    }
    
    func setupEncoder() {
        
        encoder = CSIOpusEncoder.getEncoder()
    }
    
    func printCaptureError(notification: NSNotification) {
       
        println(notification.userInfo)
        println("HALO")
    }
    
    func printCaptureStart() {
        println("Capture sessions ====== START ======")
    }
    
    func printCaptureStop() {
        println("Capture sessions ====== STOP ======")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

