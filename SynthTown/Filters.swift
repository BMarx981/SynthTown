//
//  Filters.swift
//  SynthTown
//
//  Created by Brian Marx on 12/13/16.
//  Copyright © 2016 Brian Marx. All rights reserved.
//

import Foundation
import AudioKit

class Filters {
    
    var lp = AKLowPassFilter(AKOscillator())
    var bp = AKBandPassFilter(AKOscillator())
    var hp = AKHighPassFilter(AKOscillator())
    var none = AKHighShelfFilter(AKOscillator())
    
    var f: Double
    
    init(osc: AKNode, freq: Double) {
        f = freq
        lp = AKLowPassFilter(osc, cutoffFrequency: freq)
    }
    
    func setLPFilter(osc: AKNode, freq: Double) -> AKLowPassFilter {
        
        lp = AKLowPassFilter(osc, cutoffFrequency: freq)
        return lp
    }
    
    func setHPFilter(osc: AKNode, freq: Double) -> AKHighPassFilter {
        hp = AKHighPassFilter(osc, cutoffFrequency: freq)
        return hp
    }
    
    func setBPFilter(osc: AKNode, freq: Double) -> AKBandPassFilter {
        bp = AKBandPassFilter(osc, centerFrequency: freq)
        return bp
    }
    
    func setNone(osc: AKNode, freq: Double) -> AKHighShelfFilter {
        none = AKHighShelfFilter(osc, cutOffFrequency: freq)
        return none
    }
    
    func setFreq(frequency: Double) {
        lp.cutoffFrequency = frequency
        hp.cutoffFrequency = frequency
        bp.centerFrequency = frequency
    }
    
    
}
