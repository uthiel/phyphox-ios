//
//  ExperimentTranslation.swift
//  phyphox
//
//  Created by Jonas Gessner on 11.12.15.
//  Copyright © 2015 Jonas Gessner. All rights reserved.
//  By Order of RWTH Aachen.
//

import Foundation

final class ExperimentTranslation {
    let locale: String
    
    let titleString: String
    let descriptionString: String
    let categoryString: String
    
    let translatedStrings: [String: String]?
    
    init(withLocale locale: String, strings: [String: String]?, titleString: String, descriptionString: String, categoryString: String) {
        self.locale = locale
        self.descriptionString = descriptionString
        self.categoryString = categoryString
        self.titleString = titleString
        translatedStrings = strings
    }
}
