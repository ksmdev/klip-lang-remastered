//
//  klipparse.swift
//  
//
//  Created by Kyle Mendell on 5/4/20.
//

import Foundation

func parseString(token: String, i: Character) -> KLString {
    let parseCode = "KLPARSE[*]:"
    var finalName = ""
    var finalValue = ""
    let contents = token.components(separatedBy: "=")
    var varibleValue = contents[1].components(separatedBy: "\n")
    varibleValue  = varibleValue[0].components(separatedBy: "\"")
    var varibleName  = contents[0].components(separatedBy: " ")
    finalName = varibleName[0]
    finalValue = varibleValue[1]
    return KLString(stringText:finalValue, stringName: finalName)
}
