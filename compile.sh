#!/bin/bash
echo "Bulding KLIP v0.1.0 beta"
echo "Created and Maintained By: Kyle Mendell"
swiftc main.swift ./Klip-Compiler/klip-lexer.swift ./Klip-Compiler/klipparse.swift ./KlipTypes/klipint.swift ./KlipTypes/kliplogfunc.swift ./KlipTypes/klipstring.swift klipcore.swift klippublic.swift -o klip
echo "KLIP Built. Usage ./klip filename.klip"

