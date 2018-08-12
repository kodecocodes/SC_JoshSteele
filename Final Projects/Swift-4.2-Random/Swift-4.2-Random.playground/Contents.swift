import UIKit

// MARK: - Generating Random Numbers

//: Before Swift 4.2, C APIs  had to be used to work with random numbers.  For example, to get a random number between 0 and 9, you could call `arc4random_uniform()`

let cRandom = Int(arc4random_uniform(10))

//: While this gave a random number, you had to import Foundation, it didn't work on linux, and wasn't very random thanks to modulo bias.  Now in Swift 4.2 the Standard Library includes some random API. Now to get a number between 0 and 9, use `random(in:)` on the `Int` class

let digit = Int.random(in: 0..<10)

//: This returns a random number from the provided range.  You can also call `randomElement()` directly on a range

if let anotherDigit = (0..<10).randomElement() {
  print(anotherDigit)
} else {
  print("Empty range.")
}

//: Asking for a random number this way on the range returns an optional, so it needs to be unwrapped with `if let`.  The random method also works on `Doubles`, `Floats` and `CGFloat`, and a no-argument version exists for `Boolean` so you flip a coin with a method call

let double = Double.random(in: 0..<1)
let float = Float.random(in: 0..<1)
let cgFloat = CGFloat.random(in: 0..<1)
let bool = Bool.random()

// MARK: - Shuffling Lists

//: Numbers aren't the only type to get new random features - arrays also got some attention in Swift 4.2,  If I have an array of strings, `randomElement()` can be used to get a random string from the array

let playlist = ["Nothing Else Matters", "Stairway to Heaven", "I Want to Break Free", "Yesterday"]
if let song = playlist.randomElement() {
  print(song)
} else {
  print("Empty playlist.")
}

//: As with `randomElement()` with numbers, this returns an optional, so it is unwrapped with `if let`.

//: Another new feature that arrays get that is related to random is the ability to shuffle.  Before Swift 4.2, a feature like this had to be created by hand.  Now, a simple call to `shuffled()` will do.

let shuffledPlaylist = playlist.shuffled()

//: This return a shuffled array.  To sort in place you can simply call `shuffle()`

var names = ["Cosmin", "Oana", "Sclip", "Nori"]
names.shuffle()
