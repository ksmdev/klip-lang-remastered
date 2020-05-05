//  klipcore.swift
//  klipcore
//
//  Created by Kyle Mendell on 7/20/19.
//  Copyright © 2019 Kyle Mendell. All rights reserved.
//
import Foundation

enum KLTypes {
    case KLInt
    case KLString
    case KLClass
}

var stringTokens = [String:String]()
var intTokens = [String:Int]()
var funcTokens = [String:[String:String]]()
var funcsToRun = [String:Bool]()
var currentFunc = ""
var runFunc = false

//MARK: --Open File
let fm = FileManager.default
func getFilePath(name: String) -> String {
    let file = URL(fileURLWithPath: "./" + name)
    return file.path
}

func getContentsofFile() -> String {
    var returnVal = ""
    let filename = CommandLine.arguments[1]
    let path = getFilePath(name: filename)
    if fm.fileExists(atPath: path) {
        let data = fm.contents(atPath: path)
        guard let string = String(data: data!, encoding: String.Encoding.utf8) else { return "" }
        returnVal = string
    }
    return returnVal
}
//
//MARK: --Lexer
func readCode(fc: String) {
    var token = ""
    //vars for types
    var isString = false
    var editString = false
    var isInt = false
    var editInt = false
    var printFunc = false
    var logFunc = false
    var customFunc = false
    //
    //vars
    var tokenInUse = ""
    var _ = ""
    let logDef = "KLIP[*]: "
    var logText = ""
    //
    let contents = Array(fc)
    for i in contents {
        let c = String(i)
        token += c
        if token == " " { token = "" }
//        else if token == "\n" { token = "" }
        else if token == "String" {
        isString = true; token = ""
        }
        else if token == "Int" { isInt = true; token = ""}
        else if token == "log" { logFunc = true; token = "" }
        else if token == "func" { customFunc = true; token = "" }
        else if i == "\n" {
            if isString == true {
                let string = parseString(token: token, i: i)
                if customFunc {
                    funcTokens[currentFunc] = [string.name:string.text]
                    token = ""
                    isString = false
                } else if customFunc == false {
                    stringTokens[string.name] = string.text
                    token = ""
                    isString = false
                }
                token = ""
            }
            if editString {
                var temp = token.components(separatedBy: "\"")
                stringTokens[tokenInUse] = temp[1]
                editString = false
                tokenInUse = ""
                token = ""
            }
            if isInt {
                let temp = token.components(separatedBy: "\n")
                let temp2 = temp[0].components(separatedBy: "=")
                let name = temp2[0].components(separatedBy: " ")
                let val = temp2[1].components(separatedBy: " ")
                let intName = name[0]
                intTokens[intName] = Int(val[1])
                isInt = false
                token = ""
            }
            if editInt {
                let temp = token.components(separatedBy: "\n")
                let temp2 = temp[0].components(separatedBy: " ")
                intTokens[tokenInUse] = Int(temp2[1])
                editInt = false
                token = ""
                tokenInUse = ""
            }
            token = ""
        }
        else if stringTokens.keys.contains(token) {
            tokenInUse = token
            if printFunc == false {
                token = ""; editString = true
            }
        }
        else if intTokens.keys.contains(token) {
            tokenInUse = token
            if printFunc == false {
                editInt = true; token = ""
            }
        }
        else if token == "print" { printFunc = true; token = "" }
        else if i == "{" {
            if customFunc {
//                let split = token.components(separatedBy: "()")
//                let name = split[0]
//                print(token)
//                currentFunc = name
//                print(currentFunc)
//                funcsToRun[currentFunc] = 1
                token = ""
            }
//            print(token)
        }
        else if i == "}" {
//            print(token)
            token = ""
            if customFunc {
//                print(token)
                token = ""
            }
        }
        else if i == "(" {
            if customFunc {
                let key = token.components(separatedBy: "(")
                currentFunc = key[0]
                if funcTokens.keys.contains(currentFunc) {
                    funcsToRun[currentFunc] = true
                    runFunc = true
                    customFunc = false
                }
//                print(currentFunc)
//                customFunc = false
            }
        }
        else if runFunc {
            if let val = funcsToRun[currentFunc] {
                if val == true {
                    print("running " + currentFunc)
                    if printFunc {
                        let tok = tokenInUse.components(separatedBy: "(")
                        let val = tok[1]
                        if let dict = funcTokens[currentFunc] {
                            if let text = dict[val] {
                                print(text)
                            }
                        }
                    }
                } else {
                    print("false")
                }
            }
        }
        else if token == "(\"" {
            token = ""
        }
        else if token == "\"" {
            token = ""
        }
        else if token == "()" {
            token = ""
        }
        else if i == "\"" {
            if printFunc {
                let temp = token.components(separatedBy: "\"")
                print(temp[0])
                token = ""
                printFunc = false
            }
            if logFunc {
                let temp = token.components(separatedBy: "\"")
                logText = logDef + temp[0]
                let url = URL(fileURLWithPath: "./log.txt")
                do {
                    try logText.appendLineToURL(fileURL: url)
                } catch {
                    print(error.localizedDescription)
                }
                token = ""
                logText = ""
                logFunc = false
            }
        }
        else if i == ")" {
            let temp = token.components(separatedBy: ")")
            tokenInUse = temp[0]
            if printFunc {
                if stringTokens.keys.contains(tokenInUse) {
                    guard let text = stringTokens[tokenInUse] else { return }
                    print(text)
                    token = ""
                    tokenInUse = ""
                    printFunc = false
                }
                else if intTokens.keys.contains(tokenInUse) {
                    guard let text = intTokens[tokenInUse] else { return }
                    print(text)
                    token = ""
                    tokenInUse = ""
                    printFunc = false
                }
                else if runFunc {
                    print(tokenInUse)
                }
            }
        }
    }
}



//
// MARK: -- Parse
//
func startKlip() {
    let fm = FileManager.default
    do {
      try fm.removeItem(atPath: "./log.txt")
    } catch {
        print(error.localizedDescription)
    }
    if CommandLine.arguments.count == 3 {
        if CommandLine.arguments[2] == "-c" {
            print("klipc> Compiling......")
        }
    } else {
        let fc = getContentsofFile()
        readCode(fc: fc)
        print(stringTokens, intTokens, funcTokens)
        //        parseStrings(tokens: stringTokens)
        //        parseInts(tokens: intTokens)
    }
    
}

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}


