//
//  ViewController.swift
//  FaceReconstruction
//
//  Created by Olee on 12.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var videoCamera: CvVideoCamera?
    var videoCameraDelegate = VideoCameraDelegateImplementation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoCameraDelegate.switchToProcessorWithIdentifier(FeatureGrouperIdentifier);
        
        videoCamera = CvVideoCamera(parentView: imageView)
        videoCamera?.defaultAVCaptureDevicePosition = AVCaptureDevicePosition.Front
        videoCamera?.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288
        videoCamera?.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientation.Portrait
        videoCamera?.defaultFPS = 30
        videoCamera?.grayscaleMode = false
        videoCamera?.delegate = videoCameraDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(sender: AnyObject) {
        videoCamera?.start()
    }

}



