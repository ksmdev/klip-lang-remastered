//
//  klipstring.swift
//  
//
//  Created by Kyle Mendell on 5/4/20.
//

import Foundation

class KLString: NSObject {
    
    var text: String = ""
    var name: String = ""
    var length: Int {
        return text.count
    }
    
    init(stringText: String, stringName: String) {
        self.text = stringText
        self.name = stringName
        
    }
    
}
