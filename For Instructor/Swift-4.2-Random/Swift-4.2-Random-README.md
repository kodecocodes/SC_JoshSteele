# What's new in Swift 4.2 - Random API


# Screencast Metadata

## Screencast Title

What's New in Swift 4.2 - Random API

## Screencast Description

One of the additions in Swift 4.2 is a set of API designed to make working with random
numbers easier than ever before.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0 Beta 5 or greater
* **Editor**: Xcode 10.0 Beta 5 or greater


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  In this 
screencast, I'll go over some of the highlights in Swift 4.2, which was released 
alongside Xcode 10 this Fall.

A few things before we get started.  As I mentioned - you'll need at least Xcode 10 beta 
or above to follow along with this screencast.  Also, I'd like to give a big thanks to 
Cosmin Pupaza, who wrote the What's New in Swift 4.2 tutorial, which is the basis for this 
screen cast.

Swift 4.2 introduced a series of improvements into using random numbers, adding methods 
right into the system APIs.  Let's take a look.

# DEMO

Before Swift 4.2, C APIs  had to be used to work with random numbers, and most of the methods
included modulo bias, which meant that they weren't as random as they could be.  For example, to get
 a random number between 0 and 9, I would call arc4random_uniform

`let cRandom = Int(arc4random_uniform(10))`

While this gave a random number, you had to import Foundation and this also didn't work on linux.  Now 
in Swift 4.2 the Standard Library includes some random API. Now to get a number between 0 and 9, use random(in:) on the 
Int class

`let digit = Int.random(in: 0..<10)`

This returns a random number from the provided range.  

You can also call randomElement directly on a range

```
if let anotherDigit = (0..<10).randomElement() {
  print(anotherDigit)
} else {
  print("Empty range.")
}
```

Asking for a random number this way on the range returns an optional, so it needs to 
be unwrapped with if let.  The random method also works on Doubles, Floats and CGFloat, 
and a no-argument version exists for Boolean so you flip a coin with a method call

`let double = Double.random(in: 0..<1)`
`let float = Float.random(in: 0..<1)`
`let cgFloat = CGFloat.random(in: 0..<1)`
`let bool = Bool.random()`

Numbers aren't the only type to get new random features - arrays also got some 
attention in Swift 4.2.  If I have an array of strings, randomElement can be used to get 
a random string from the array:

```
let playlist = ["Nothing Else Matters", "Stairway to Heaven", "I Want to Break Free", "Yesterday"]
if let song = playlist.randomElement() {
  print(song)
} else {
  print("Empty playlist.")
}
```

As with randomElement with numbers, this returns an optional, so it's unwrapped with if let.

Another new feature that arrays get that is related to random is the ability to shuffle.  
Before Swift 4.2, a feature like this had to be created by hand.  Now, a simple call to 
shuffled will do.

`let shuffledPlaylist = playlist.shuffled()`

This return a shuffled array.  To sort in place you can simply call shuffle(). Here, I've defined
an array with some names in it - I can invoke shuffle() and then output the array to see how
they have been reordered.  

`var names = ["Cosmin", "Oana", "Sclip", "Nori"]`
`names.shuffle()`
`names`

# Outro

Swift 4.2 didn't give us ABI stability like some had hoped (that's coming in Swift 5) 
but it did include some really nice additions to improve the overall usefulness of the 
language.

The old ways of working with random numbers before Swift 4.2 involved using C APIs that 
weren't always as random as they could be thanks to some modulo bias.  The new random API
 in the standard library helps make working with random numbers a breeze
 
 That's a quick look at some of the improvements in Swift 4.2.  Continue to come back to 
 raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!
