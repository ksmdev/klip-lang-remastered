//
//  klipint.swift
//
//
//  Created by Kyle Mendell on 5/4/20.
//

import Foundation

class KLInt: NSObject {
    
    var value: Int = 0
    var name: String = ""
    
    init(intName: String, intValue: Int) {
        self.value = intValue
        self.name = intName
        
    }
    
}
