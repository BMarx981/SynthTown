//
//  Model.swift
//  SynthTown
//
//  Created by Brian Marx on 12/7/16.
//  Copyright © 2016 Brian Marx. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class Model {
    
    var osc = AKOscillator()
    
    var filter = Filters()
    
    var mainFreq = 1000.0
    var mainFilterFreq = 1000.0
    let highShelfFreq = 20000.0
    
    var mixer = AKMixer()
    
    init() {
        osc = AKOscillator(waveform: AKTable(.sawtooth), frequency: mainFreq)
        
        setMixerInput(filterInput: filter)
        setAudioKitOutput(mix: mixer)
        
    }//end init
    
    func PlayOsc() {
        osc.start()
        mixer.start()
    }
    
    func StopOsc() {
        osc.stop()
        mixer.stop()
    }
    
    //sets the oscillator type
    func setOscillator(oscType: String) {
        osc.stop()
        switch oscType {
            case "saw":
                osc = AKOscillator(waveform: AKTable(.sawtooth), frequency: mainFreq)
            case "square":
                osc = AKOscillator(waveform: AKTable(.square),frequency: mainFreq)
            case "sine":
                osc = AKOscillator(waveform: AKTable(.sine), frequency: mainFreq)
            case "triangle":
                osc = AKOscillator(waveform: AKTable(.triangle), frequency: mainFreq)
            default:
                break
        }
        
        osc.start()
    }
    
    //sets the filter type
    func setFilter(filterType: String) {
        mixer.stop()
        switch filterType {
            case "lp":
                filter.setLPFilter(osc: osc, freq: mainFilterFreq)
            case "bp":
                filter.setBPFilter(osc: osc, freq: mainFilterFreq)
            case "hp":
                filter.setHPFilter(osc: osc, freq: mainFilterFreq)
            case "none":
                filter.setNone(osc: osc, freq: highShelfFreq)
            default:
                break
        }
        setMixerInput(filterInput: filter)
        setAudioKitOutput(mix: mixer)
    }//end setFilter
    
    //sets the mixer to a filter
    func setMixerInput(filterInput: AKNode) {
        mixer = AKNode() as! AKMixer
        mixer = AKMixer(filterInput)
        mixer.start()
    }
    
    //sets the frequency of the oscillator
    func setOscFrequency(freq: Double) {
        osc.frequency = freq
        mainFreq = freq
    }
    
    func setFilterFreq(freq: Double) {
        filter.setFreq(frequency: freq)
    }
    
    //Starts the audioKit engine
    func startAudioEngine() {
        AudioKit.start()
    }
    
    //sets the audio output for the audiokit engine
    func setAudioKitOutput(mix: AKMixer) {
        AudioKit.output = mix
    }
}//end Model class
