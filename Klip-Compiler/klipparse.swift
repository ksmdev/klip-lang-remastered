//
//  klipparse.swift
//  
//
//  Created by Kyle Mendell on 5/4/20.
//


import Foundation

let parseCode = "KLPARSE[*]:"

func parseLog(line: String) -> String {
    var finalValue = ""
    var lineContents = line.components(separatedBy: "\"")
    lineContents = lineContents[1].components(separatedBy: "\"")
    finalValue = lineContents[0]
    return finalValue
}

func parsePrint(line: String) -> Any {
    var stat = line.components(separatedBy: "(")
    stat = stat[1].components(separatedBy: ")")
    if stat[0].contains("\"") {
        stat = stat[0].components(separatedBy: "\"")
        return stat[1]
    } else {
        var rv: Any?
        if let val = klipStrings[stat[0]]{
            rv = val 
        } else if let val = klipInts[stat[0]] {
            rv = val
        }
        return rv!
    }
}

func parseString(token: String, editVarible: String, stringEdit: Bool) -> KLString {
    if stringEdit {
        var stringContents = token.components(separatedBy: "\"")
        let updatedString = stringContents[1]
        return KLString(stringText: updatedString, stringName: editVarible)
    } else {
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
}

func parseStringv2(line: String) -> KLString {
            var finalName = ""
            var finalValue = ""
            var varibleValue = line.components(separatedBy: "=")
            varibleValue = varibleValue[1].components(separatedBy: "\"")
            finalValue = varibleValue[1]
            var varibleName  = line.components(separatedBy: "=")
            varibleName = varibleName[0].components(separatedBy: "String")
            varibleName = varibleName[1].components(separatedBy: " ")
            finalName = varibleName[1]
        return KLString(stringText:finalValue, stringName: finalName)
}

func parseInt(token: String, editVarible: String, intEdit: Bool) -> KLInt {
    if intEdit {
        var intContents = token.components(separatedBy: "\n")
        intContents = intContents[0].components(separatedBy: " ")
        let updatedInt = Int(intContents[1])!
        return KLInt(intName: editVarible, intValue: updatedInt)
    } else {
        var intName = ""
        var intValue = 0
        let contents = token.components(separatedBy: "=")
        var varibleValue = contents[1].components(separatedBy: "\n")
        varibleValue  = varibleValue[0].components(separatedBy: " ")
        var varibleName  = contents[0].components(separatedBy: " ")
        intValue = Int(varibleValue[1])!
        intName = varibleName[0]
        return KLInt(intName: intName, intValue: intValue)
    }
}

func parseIntv2(line: String) -> KLInt {
        var finalName = ""
        var finalValue = 0
        var varibleValue = line.components(separatedBy: "=")
        varibleValue = varibleValue[1].components(separatedBy: " ")
        finalValue = Int(varibleValue[1])!
        var varibleName  = line.components(separatedBy: "=")
        varibleName = varibleName[0].components(separatedBy: "Int")
        varibleName = varibleName[1].components(separatedBy: " ")
        finalName = varibleName[1]
    return KLInt(intName: finalName, intValue: finalValue)
}
