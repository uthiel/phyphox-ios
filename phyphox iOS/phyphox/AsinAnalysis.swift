//
//  AsinAnalysis.swift
//  phyphox
//
//  Created by Sebastian Kuhlen on 06.10.16.
//  Copyright © 2016 RWTH Aachen. All rights reserved.
//

import Foundation
import Accelerate

final class AsinAnalysis: UpdateValueAnalysis {
    private let deg: Bool
    
    override init(inputs: [ExperimentAnalysisDataIO], outputs: [ExperimentAnalysisDataIO], additionalAttributes: [String : AnyObject]?) throws {
        deg = boolFromXML(additionalAttributes, key: "deg", defaultValue: false)
        try super.init(inputs: inputs, outputs: outputs, additionalAttributes: additionalAttributes)
    }
    
    override func update() {
        updateAllWithMethod { array -> [Double] in
            var results = array
            
            vvasin(&results, array, [Int32(array.count)])
            
            if self.deg {
                var f = 180.0/M_PI
                vDSP_vsmulD(results, 1, &f, &results, 1, vDSP_Length(results.count))
            }
            
            return results
        }
    }
}