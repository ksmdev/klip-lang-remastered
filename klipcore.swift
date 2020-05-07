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
    var editString = false
    var editInt = false
    var printFunc = false
    var logFunc = false
    var customFunc = false
    //
    //vars
    var tokenInUse = ""
    let logDef = "KLIP[*]: "
    var logText = ""
    //
    let contents = Array(fc)
    for i in contents {
        let c = String(i)
        token += c
        if token == " " { token = "" }
//        else if token == "\n" { token = "" }
        else if i == "\n" {
            if editString {
                let updatedString = parseString(token: token, editVarible: tokenInUse, stringEdit: true)
                stringTokens[tokenInUse] = updatedString.text
                editString = false
                tokenInUse = ""
                token = ""
            }
            if editInt {
                let updateInt = parseInt(token: token, editVarible: tokenInUse, intEdit: true)
                intTokens[tokenInUse] = updateInt.value
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
        // readCode(fc: fc)
        runLexer(with: fc)
        print(klipStrings, klipInts, funcTokens)
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

// extension String {
//     var lines: [String] {
//         var result: [String] = []
//         enumerateLines { line, _ in result.append(line) }
//         return result
//     }
// }


