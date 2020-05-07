//KLIP Lang Lexer v2
//Made By: Kyle Mendell

import Foundation

func runLexer(with text: String) {

	let parseCode = "KLPARSE[*]:"

	text.enumerateLines { line, _ in 
		let tokenContents = line.components(separatedBy: " ")
		let usedToken = tokenContents[0]
		if line.prefix(7) == "String " {
			let string = parseStringv2(line: line)
			klipStrings[string.name] = string.text
		} else if line.prefix(3) == "Int" {
        	let int = parseIntv2(line: line)
        	klipInts[int.name] = int.value
		} else if line.prefix(5) == "print" {
			let printStatement = parsePrint(line: line)
			print(printStatement)
		} else if line.prefix(3) == "log" {
			let logText = parseLog(line: line)
			addLog(of: logText)
		} else if let _ = klipStrings[usedToken] {
			print("\(parseCode) \(usedToken) is mutated")
		} else if let _ = klipInts[usedToken] {
			print("\(parseCode) \(usedToken) is mutated")
		} else {
			print(line)
		}
	}

}