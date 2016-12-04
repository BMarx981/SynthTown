//
//  ViewController.swift
//  SynthTown
//
//  Created by Brian Marx on 11/30/16.
//  Copyright © 2016 Brian Marx. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    //class variables***************************
    var osc = AKOscillator(waveform: AKTable()) {
        willSet {
            osc.stop()
        }
        didSet{
            osc.play()
        }
    }
    
    var mixer = AKMixer() {
        willSet {
            osc.stop()
        }
        didSet{
            osc.play()
        }
    }
    
    var lpFilter = AKKorgLowPassFilter(AKOscillator(), cutoffFrequency: 1000.0)
    var bpFilter = AKBandPassFilter(AKOscillator(), centerFrequency: 1000.0)
    var hpFilter = AKHighPassFilter(AKOscillator(), cutoffFrequency: 1000.0)
    var emptyFilter = AKNode()
    var selectedFilter = Int()
    
    var firstPlayed: Bool = false
    
    var mainFreq: Double = 0.0
    
    var filterFreq: Float = 0.0
    //end class variables************************
    
    //Oscillator Selector
    @IBAction func OscSelector(_ sender: UISegmentedControl) {
        let val = sender.selectedSegmentIndex
        switch val {
        case 0:
            osc = AKOscillator(waveform: AKTable(.sawtooth))
        case 1:
            osc = AKOscillator(waveform: AKTable(.square))
        case 2:
            osc = AKOscillator(waveform: AKTable(.sine))
        case 3:
            osc = AKOscillator(waveform: AKTable(.triangle))
        default:
            break;
        }
        osc.frequency = mainFreq
        
        mixer.connect(osc)
    }
    
    //Play button
    @IBAction func PlayButton(_ sender: UIButton) {
        if firstPlayed == false {
            firstPlay()
            sender.setTitle("Stop", for: .normal)
            sender.setTitleColor(UIColor.red, for: .normal)
        }
        PlayStop(sender: sender)
    }
    
    //Function PlayStop will stop the synth if its playing or play it if it's stopped
    func PlayStop(sender: UIButton) {
        if osc.isPlaying {
            osc.stop()
            sender.setTitle("Play", for: .normal)
            sender.setTitleColor(UIColor.blue, for: .normal)
        } else {
            osc.play()
            sender.setTitle("Stop", for: .normal)
            sender.setTitleColor(UIColor.red, for: .normal)
        }
    }//end PlayStop
    
    //OscFreqSlider************************************
    @IBAction func OscFreqSlider(_ sender: UISlider) {
        osc.frequency = pow(10.0, Double(sender.value))
        mainFreq = osc.frequency
    }
    
    //FilterSelector*********************************************
    @IBAction func FilterSelector(_ sender: UISegmentedControl) {
        
        let val = sender.selectedSegmentIndex
        selectedFilter = val
        switch val {
        case 0:
            lpFilter = AKKorgLowPassFilter(osc, cutoffFrequency: Double(filterFreq))
            print(String(lpFilter.cutoffFrequency))
            mixer.connect(lpFilter)
        case 1:
            bpFilter = AKBandPassFilter(osc, centerFrequency: Double(filterFreq))
            mixer.connect(bpFilter)
        case 2:
            hpFilter = AKHighPassFilter(osc, cutoffFrequency: Double(filterFreq))
            mixer.connect(hpFilter)
        case 3:
            emptyFilter = AKLowPassFilter(osc, cutoffFrequency: 20000.0)
            mixer.connect(emptyFilter)
        default:
            break
        }
    }//end FilterSelector
    
    //Filter Frequency Slider***************************************************
    @IBAction func FilterFreqSlider(_ sender: UISlider) {
        filterFreq = powf(10.0, sender.value)
        lpFilter.cutoffFrequency = Double(filterFreq)
        bpFilter.centerFrequency = Double(filterFreq)
        hpFilter.cutoffFrequency = Double(filterFreq)
    }

    //viewDidLoad***************************************************************
    override func viewDidLoad() {
        
        super.viewDidLoad()

        AudioKit.output = mixer
        AudioKit.start()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //didReceiveSomeShit********************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func firstPlay() {
        osc = AKOscillator(waveform: AKTable(.sawtooth))
        lpFilter = AKKorgLowPassFilter(osc, cutoffFrequency: Double(filterFreq))
        mixer.connect(lpFilter)
        osc.play()
        firstPlayed = true
    }//end firstPlay
}//end ViewController class

