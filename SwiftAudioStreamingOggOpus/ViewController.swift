//
//  ViewController.swift
//  SwiftAudioStreamingOggOpus
//
//  Created by Zel Marko on 01/07/15.
//  Copyright (c) 2015 Zel Marko. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate {
    
//    var engine = AVAudioEngine()
    var session: AVCaptureSession!
    var deviceInput: AVCaptureDeviceInput!
    var output: AVCaptureAudioDataOutput!
    var sessionQueue: dispatch_queue_t!
    var encoder: CSIOpusEncoder!
    var bufferCopy: Unmanaged<CMSampleBuffer>?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupEncoder()
            }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        session = AVCaptureSession()
        
        let microphone = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        println()
        
        var error: NSError?
        
        deviceInput = AVCaptureDeviceInput.deviceInputWithDevice(microphone, error: &error) as! AVCaptureDeviceInput
        
        if deviceInput != nil {
            println(deviceInput.device)
        }
        else {
            println(error!.localizedDescription)
        }
        
        output = AVCaptureAudioDataOutput()
        sessionQueue = dispatch_queue_create("AudioQueue", nil)
        
            session.beginConfiguration()
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            else {
                println("Cannot add Input to session")
            }
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
        
        if (bufferCopy != nil) {
            bufferCopy == nil
        }
        
        if CMSampleBufferCreateCopy(kCFAllocatorDefault, sampleBuffer, &bufferCopy) == noErr {
            
            goEncodeForMe(bufferCopy!.takeRetainedValue())
//            println("Copy: \(bufferCopy!.takeRetainedValue())")
        }
        else {
            println("Failed to copy sampleBuffer")
        }
        
        
        
        
    }
    
    func goEncodeForMe(buffer: CMSampleBuffer) {
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            let encodedSamples = self.encoder.encodeSample(buffer)
//            println(encodedSamples)
//        })
        let encodedSamples = self.encoder.encodeSample(buffer)
            println(encodedSamples)

        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
                        
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

