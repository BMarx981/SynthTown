//
//  ViewController.swift
//  SynthTown
//
//  Created by Brian Marx on 11/30/16.
//  Copyright © 2016 Brian Marx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var synth = Model()

    //Oscillator Selector
    @IBAction func OscSelector(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            synth.setOscillator(oscType: "saw")
        case 1:
            synth.setOscillator(oscType: "square")
        case 2:
            synth.setOscillator(oscType: "sine")
        case 3:
            synth.setOscillator(oscType: "triangle")
        default:
            break
        }
    }
    
    //Play button
    @IBAction func PlayButton(_ sender: UIButton) {
        PlayStop(sender: sender)
    }
    
    //Function PlayStop will stop the synth if its playing or play it if it's stopped
    func PlayStop(sender: UIButton) {
        print(synth.mixer.isPlaying)
        if synth.mixer.isPlaying {
            synth.StopOsc()
            sender.setTitle("Play", for: .normal)
            sender.setTitleColor(UIColor.blue, for: .normal)
        } else {
            synth.PlayOsc()
            sender.setTitle("Stop", for: .normal)
            sender.setTitleColor(UIColor.red, for: .normal)
        }
    }//end PlayStop
    
    //OscFreqSlider************************************
    @IBAction func OscFreqSlider(_ sender: UISlider) {
        synth.setOscFrequency(freq: pow(10.0, Double(sender.value)))
    }
    
    
    //FilterSelector*********************************************
    @IBAction func FilterSelector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            synth.setFilter(filterType: "lp")
        case 1:
            synth.setFilter(filterType: "bp")
        case 2:
            synth.setFilter(filterType: "hp")
        case 3:
            synth.setFilter(filterType: "none")
        default:
            break
        }
    }//end FilterSelector
    
    //Filter Frequency Slider***************************************************
    @IBAction func FilterFreqSlider(_ sender: UISlider) {
        
        synth.mainFilterFreq = pow(10.0, Double(sender.value))
    }//end filter selector

    //viewDidLoad***************************************************************
    override func viewDidLoad() {
        
        super.viewDidLoad()
        synth.startAudioEngine()
        // Do any additional setup after loading the view, typically from a nib.
    }//end viewDidLoad

    //didReceiveSomeShit********************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}//end ViewController class

