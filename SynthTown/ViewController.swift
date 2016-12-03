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
    
    var osc = AKOscillator(waveform: AKTable()) {
        willSet {
            osc.stop()
        }
        didSet{
            osc.play()
        }
    }
    
    var mixer = AKMixer()
    
    var filterFreq: Float = 1000.0
    
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
            osc = AKOscillator(waveform: AKTable(.sawtooth))
        }
        mixer.connect(osc)
    }
    
    //Play button
    @IBAction func PlayButton(_ sender: UIButton) {
        PlayStop(sender: sender)
    }
    
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
    }
    
    //OscFreqSlider************************************
    @IBAction func OscFreqSlider(_ sender: UISlider) {
        osc.frequency = pow(10.0, Double(sender.value))
        //print(String(osc.frequency))
    }
    
    //FilterSelector
    @IBAction func FilterSelector(_ sender: UISegmentedControl) {
        
        var lpFilter = AKLowPassFilter(osc, cutoffFrequency: Double(filterFreq))
        var bpFilter = AKBandPassFilter(osc, centerFrequency: Double(filterFreq))
        var hpFilter = AKHighPassFilter(osc, cutoffFrequency: Double(filterFreq))
        
        let val = sender.selectedSegmentIndex
        switch val {
        case 0:
            
            lpFilter = AKLowPassFilter(osc, cutoffFrequency: Double(filterFreq))
            
        case 1:
            
            bpFilter = AKBandPassFilter(osc, centerFrequency: Double(filterFreq))
            
        case 2:
            
            hpFilter = AKHighPassFilter(osc, cutoffFrequency: Double(filterFreq))
            
        default:
            lpFilter = AKLowPassFilter(osc, cutoffFrequency: Double(filterFreq))
        }
    }
    
    //Filter Frequency Slider
    @IBAction func FilterFreqSlider(_ sender: UISlider) {
        filterFreq = powf(10.0, sender.value)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioKit.output = mixer
        AudioKit.start()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

