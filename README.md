# Klip Language

Klip is a new front end programming language built upon swift

## Updates!

I have toatally rewritten the lexer and the parser for klip, it is now more efficient, for it reads each line on its own and not the whole file, each type class that you create in klip (Int, String, etc) now all have the own allocated memory and individual class.

## Known Issues

```dart
String myString = "this is my string"
```
That varible above will actually be name "my" and not myString this is a issue with the new parser/lexer and will be addressed soon!

## Installation

Make sure you have the xcode-select tools installed then to compile the klip binary run

First, cd into the master directory that you just downloaded then run

```bash
./compile.sh
```

## Usage

In the directory you klip binary was created in run

```bash
./klip _FILENAME_.klip
```

IMPORTANT: _FILENAME_ needs to be replaced with your actually file name!

## File Template
```dart
print("Welcome to Klip Lang!")
print("Made By: Kyle Mendell")
String myText = "I Love This"

myText = "this is my new text"

Int myInt = 10

log("this will be logged to log.txt")
log("im loving klip lang")
```

Everything you see in the file above is included in klip this file will be updated when new features are added. If you try to write different code then whats above you will break the binary!

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Help
If you do need help or have any questions, open a issue and ill respond with some help or advice for you!

## Ending
Id just like to say thank you for chossing this programming language, it may not be much as of now, but i have big plans for the future, So stay tuned!

## License
[MIT](https://choosealicense.com/licenses/mit/)
