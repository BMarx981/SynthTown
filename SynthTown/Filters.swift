//
//  Filters.swift
//  SynthTown
//
//  Created by Brian Marx on 12/13/16.
//  Copyright © 2016 Brian Marx. All rights reserved.
//

import Foundation
import AudioKit

class Filters: AKNode {
    
    var lp = AKLowPassFilter(AKOscillator())
    var bp = AKBandPassFilter(AKOscillator())
    var hp = AKHighPassFilter(AKOscillator())
    var none = AKHighShelfFilter(AKOscillator(), cutOffFrequency: 20000.0)
    
    var f: Double
    
    override init () {
        f = 1000.0
    }
    
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
