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
    
    var lpFilter = AKLowPassFilter(AKOscillator())
    var bpFilter = AKBandPassFilter(AKOscillator())
    var hpFilter = AKHighPassFilter(AKOscillator())
    var blankFilter = AKHighShelfFilter(AKOscillator(), cutOffFrequency: 20000.0)
    var filterString: String
    
    var mainFreq: Double?
    var mainFilterFreq: Double?
    
    var mixer = AKMixer()
    
    init() {
        mainFilterFreq = 1000.0
        mainFreq = 1000.0
        osc = AKOscillator(waveform: sawTable, frequency: mainFreq!)

        filterString = "lp"
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
        filterString = filterType
        mixer.stop()
        switch filterType {
            case "lp":
                filter = AKLowPassFilter(osc, cutoffFrequency: mainFilterFreq!)
            case "bp":
                filter = AKBandPassFilter(osc, centerFrequency: mainFilterFreq!)
            case "hp":
                filter = AKHighPassFilter(osc, cutoffFrequency: mainFilterFreq!)
            case "none":
                filter = blankFilter
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
    
    //FILTER SETUP FUNCTIONS ********************************
    //sets the frequency of the high pass filter
    func sethpFilterFrequency(freq: Double) {
        hpFilter.cutoffFrequency = freq
        mainFilterFreq = freq
    }
    
    //sets the cuttoff Freqency of the low pass filter
    func setlpFilterFrequency(freq: Double) {
        lpFilter.cutoffFrequency = freq
        mainFilterFreq = freq
    }
    
    //sets the center frequency of the high pass filter
    func setbpFilterFrequency(freq: Double) {
        bpFilter.centerFrequency = freq
        mainFilterFreq = freq
    }
    
    //END FILTER SETUP FUNCTIONS*** END**********************
    
    //Starts the audioKit engine
    func startAudioEngine() {
        AudioKit.start()
    }
    
    //sets the audio output for the audiokit engine
    func setAudioKitOutput(mix: AKMixer) {
        AudioKit.output = mix
    }
}//end Model class
