//
//  ViewController.swift
//  GoLiveStarter
//
//  Created by Mitchell Sweet on 8/18/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import UIKit
import ReplayKit

// There will be an error here which be resolved once delegate functions are added.
class ViewController: UIViewController, RPBroadcastActivityViewControllerDelegate {
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var colorSelector: UISegmentedControl!
    @IBOutlet var colorView: UIView!
    @IBOutlet var broadcastButton: UIButton!
    @IBOutlet var micSwitch: UISwitch!
    @IBOutlet var micLabel: UILabel!
    
    let controller = RPBroadcastController()
    let recorder = RPScreenRecorder.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "You are not live"
    }
    
    @IBAction func didPressBroadcastButton() {
        // Called when broadcast button is tapped. Runs functions to start or stop broadcast.
        if controller.isBroadcasting {
            stopBroadcast()
        }
        else {
            startBroadcast()
        }
    }
    
    func startBroadcast() {
        
        //1
        RPBroadcastActivityViewController.load { broadcastAVC, error in
            
            //2
            guard error == nil else {
                print("Cannot load Broadcast Activity View Controller.")
                return
            }
            
            //3
            if let broadcastAVC = broadcastAVC {
                broadcastAVC.delegate = self
                self.present(broadcastAVC, animated: true, completion: nil)
            }
        }
    }
    
    func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController,
                                         didFinishWith broadcastController: RPBroadcastController?,
                                         error: Error?) {
        //1
        guard error == nil else {
            print("Broadcast Activity Controller is not available.")
            return
        }
        
        //2
        broadcastActivityViewController.dismiss(animated: true) {
            //3
            broadcastController?.startBroadcast { error in
                //4
                //TODO: Broadcast might take a few seconds to load up. I recommend that you add an activity indicator or something similar to show the user that it is loading.
                //5
                if error == nil {
                    print("Broadcast started successfully!")
                    // UI must always be changed in main thread. 
                    DispatchQueue.main.async {
                        self.broadcastStarted()
                    }
                }
            }
        }
    }
    
    func stopBroadcast() {
        
        controller.finishBroadcast { error in
            if error == nil {
                print("Broadcast ended")
                self.broadcastEnded()
            }
        }
    }
    
    
    func broadcastStarted() {
        // Called to update the UI when a broadcast starts.
        broadcastButton.setTitle("Stop Broadcast", for: .normal)
        statusLabel.text = "You are live!" // Any app that does not notify the user that they are live will be rejected in app review.
        statusLabel.textColor = UIColor.red
        micSwitch.isHidden = false
        micLabel.isHidden = false
    }
    
    func broadcastEnded() {
        // Called to update the UI when a broadcast ends.
        broadcastButton.setTitle("Start Broadcast", for: .normal)
        statusLabel.text = "You are not live"
        statusLabel.textColor = UIColor.black
        micSwitch.isHidden = true
        micLabel.isHidden = true
    }
    
    
    @IBAction func enableMic(sender: UISwitch) {
        // Called when microphone switch is toggled.
        
        if sender.isOn {
            // Enable Microphone
            recorder.isMicrophoneEnabled = true
        }
        else {
            // Disable Microphone
            
        }
        
    }

    
    
    // Function for handling the changing of the colored square.
    // This function does not need to be edited for tutorial. 
    @IBAction func colorSelector(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            colorView.backgroundColor = UIColor.red
        case 1:
            colorView.backgroundColor = UIColor.blue
        case 2:
            colorView.backgroundColor = UIColor.orange
        case 3:
            colorView.backgroundColor = UIColor.green
        default:
            colorView.backgroundColor = UIColor.red
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("Memory warning triggered. If running this app on an older device, you might want to remove some apps from multitasking.")
    }


}

