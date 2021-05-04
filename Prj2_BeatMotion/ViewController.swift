//
//  ViewController.swift
//  Prj2_BeatMotion
//
//  Created by Alex Fuoco on 4/20/21.
//

import UIKit
import AVFoundation
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var PlayBTN: UIButton!
    @IBOutlet weak var RecordBTN: UIButton!
    
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
    var soundRecorder = AVAudioRecorder()
    var soundPlayer = AVAudioPlayer()
    let motion = CMMotionManager()
    var timer = Timer()
    var prevX = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func play(_ url: URL) throws {
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 2: create the audio player
        let audioPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        engine.attach(speedControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        audioPlayer.scheduleFile(file, at: nil)

        // 6: start the engine, player and gyro
        try engine.start()
        audioPlayer.play()
        startGyros()
        print(speedControl.rate)
    }

    @IBAction func playBTN(_ sender: Any) {
        let path = Bundle.main.path(forResource: "waves", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        
        //play the audio and create the audio player
        do {
            try play(url)
            print (path)
            print (url)
        } catch  {
            print ("There is an issue with this code!")
            print (path)
            print (url)
        }
        
    }
    
    func startGyros() {
       if motion.isGyroAvailable {
          self.motion.gyroUpdateInterval = 0.1 / 60.0
          self.motion.startGyroUpdates()
          print("Gyro Available, starting input")

          // Configure a timer to fetch the accelerometer data.
          self.timer = Timer(fire: Date(), interval: (0.1/60.0),
                 repeats: true, block: { (timer) in
             // Get the gyro data.
             if let data = self.motion.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z

                // Use the gyroscope data in your app.
                self.changeSpeed(y: y)
                self.changePitch(x: x)
                
             }
          })

          // Add the timer to the current run loop.
          RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
       }
    }

    func stopGyros() {
        if self.timer != nil {
            self.timer.invalidate()
            
            self.motion.stopGyroUpdates()
       }
    }

    
    func changePitch(x: Double) {
        //Makes pitch higher or lower based on X rotation
        if ( x <= -2.0 ) {
            print("Rotation less than -2.0, pitch at -200")
            pitchControl.pitch = -200
            print(x)
        } else if ( x <= -1.0  && x > -2.0){
            print("Rotation less than -1.0, pitch at -100")
            pitchControl.pitch = -100
            print(x)
        }else if( x > -1.0  && x <= -0.5 ) {
            print("Rotation less than -0.5, pitch at -50")
            pitchControl.pitch = -50
            print(x)
        }else if( x > -0.5 && x < 0.5  ) {
            print("No Rotation, pitch is normal")
            pitchControl.pitch = 0
            print(x)
        }else if( x >= 0.5  && x < 1.0 ) {
            print("Rotation greater than 0.5, pitch at 50")
            pitchControl.pitch = 50
            print(x)
        }else if( x >= 1.0  && x < 2.0 ) {
            print("Rotation greater than 1.0, pitch at 100")
            pitchControl.pitch = 100
            print(x)
        }else if( x >= 2.0) {
            print("Rotation greater than 2.0, pitch at 200")
            pitchControl.pitch = 200
            print(x)
        }
        print(pitchControl.pitch)
    }
    
    func changeSpeed(y: Double) {
        //Makes pitch higher or lower based on Y rotation
        if ( y <= -2.0 ) {
            print("Rotation less than -2.0, speed at .25")
            speedControl.rate = 0.25
            print(y)
        } else if ( y <= -1.0  && y > -2.0){
            print("Rotation less than -1.0, speed at .5")
            speedControl.rate = 0.5
            print(y)
        }else if( y > -1.0  && y <= -0.5 ) {
            print("Rotation less than -0.5, speed at .75")
            speedControl.rate = 0.75
            print(y)
        }else if( y > -0.5 && y < 0.5  ) {
            print("No Rotation, speed is normal")
            speedControl.rate = 1.0
            print(y)
        }else if( y >= 0.5  && y < 1.0 ) {
            print("Rotation greater than 0.5, speed at 1.25")
            speedControl.rate = 1.25
            print(y)
        }else if( y >= 1.0  && y < 2.0 ) {
            print("Rotation greater than 1.0, speed at 1.5")
            speedControl.rate = 1.5
            print(y)
        }else if( y >= 2.0) {
            print("Rotation greater than 02.0, speed at 1.75")
            speedControl.rate = 1.75
            print(y)
        }
        print(pitchControl.pitch)
    }

    
}

