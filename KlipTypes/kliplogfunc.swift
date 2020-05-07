//Klip Log Function v1
//Made By: Kyle Mendell

import Foundation

func addLog(of text: String) {
	let logFileUrl = URL(fileURLWithPath: "./log.txt")
	let logText = "KLIP[*]: " + text
	do {
		try logText.appendLineToURL(fileURL: logFileUrl)
	}
	catch {
		print(error.localizedDescription)
	}
}