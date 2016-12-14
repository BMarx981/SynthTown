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
    
    let sawTable = AKTable(.sawtooth)
    let sineTable = AKTable(.sine)
    let squareTable = AKTable(.square)
    let triangleTable = AKTable(.triangle)
    
    var osc = AKOscillator()
    
    var filter = AKNode()
    
    var mainFreq: Double?
    var mainFilterFreq: Double?
    let highShelfFreq: Double
    
    var mixer = AKMixer()
    
    init() {
        mainFilterFreq = 1000.0
        mainFreq = 1000.0
        osc = AKOscillator(waveform: sawTable, frequency: mainFreq!)

        filter = AKLowPassFilter(osc, cutoffFrequency: mainFilterFreq!)
        
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
                osc = AKOscillator(waveform: sawTable, frequency: mainFreq!)
            case "square":
                osc = AKOscillator(waveform: squareTable,frequency: mainFreq!)
            case "sine":
                osc = AKOscillator(waveform: sineTable, frequency: mainFreq!)
            case "triangle":
                osc = AKOscillator(waveform: triangleTable, frequency: mainFreq!)
            default:
                break
        }
        
        osc.start()
    }
    
    //sets the filter type
    func setFilter(filterType: String) {
        mixer.stop()
        let filtered = Filters(osc: osc, freq: mainFilterFreq!)
        switch filterType {
            case "lp":
                filter = filtered.setLPFilter(osc: osc, freq: mainFilterFreq!)
            case "bp":
                filter = filtered.setBPFilter(osc: osc, freq: mainFilterFreq!)
            case "hp":
                filter = filtered.setHPFilter(osc: osc, freq: mainFilterFreq!)
            case "none":
                filter = filtered.setNone(osc: osc, freq: highShelfFreq)
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
    }
    
    //sets the frequency of the oscillator
    func setOscFrequency(freq: Double) {
        osc.frequency = freq
        mainFreq = freq
    }
    
    func setFilterFreq(freq: Double) {
        
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
