# What's new in Swift 4.2 - New Sequence Methods


# Screencast Metadata

## Screencast Title

What's New in Swift 4.2 - New Sequence Methods

## Screencast Description

Swift 4.2 refined some of the syntax dealing with finding the first instance of an item in a collection, as well as some new ones to find the last instance.  

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

Swift 4.2 introduced some new methods to help deal with sequences, eliminating the need 
to roll your own code.  Let's take a look.


# DEMO

`let ages = ["ten", "twelve", "thirteen", "nineteen", "eighteen", "seventeen", "fourteen", "eighteen", "fifteen", "sixteen", "eleven"]`

Here I have an array of strings that represent ages from 10 to 19.  

In Swift 4.1, if I wanted to find the first instance of the string that matched a given criteria, I would use the first(where:) method, and if I wanted to find the index of that instance, I would use index(where:)

```
//Swift 4.1 way - will write this whole thing in demo
if let firstTeen = ages.first(where: { $0.hasSuffix("teen") }),
    let firstIndex = ages.index(where: { $0.hasSuffix("teen") }) {
  print("Teenager number \(firstIndex + 1) is \(firstTeen) years old.")
} else {
  print("No teenagers around here.")
}
```
Also I could use index(of:) to find an instance of a specific string in the array

```
if let firstTeen = ages.first(where: { $0.hasSuffix("teen") }),
    let firstIndex = ages.index(where: { $0.hasSuffix("teen") }),
    //2 - add this line to above
    let firstMajorIndex = ages.index(of: "eighteen") {
  print("Teenager number \(firstIndex + 1) is \(firstTeen) years old.")
  //2a - add this line to above
  print("Teenager number \(firstMajorIndex + 1) isn't a minor anymore.")
} else {
  print("No teenagers around here.")
}
```

Swift 4.2 cleans up that syntax a bit - the first method remains the same, but index(where:) and index(of:) are now firstIndex(where:) and firstIndex(of:) respectively:

```
//During demo, change the above code to look like this:
//Swift 4.2 way include first and firstIndex, where 4.1 is first and index
if let firstTeen = ages.first(where: { $0.hasSuffix("teen") }),
    let firstIndex = ages.firstIndex(where: { $0.hasSuffix("teen") }),
    let firstMajorIndex = ages.firstIndex(of: "eighteen") {
  print("Teenager number \(firstIndex + 1) is \(firstTeen) years old.")
  print("Teenager number \(firstMajorIndex + 1) isn't a minor anymore.")
} else {
  print("No teenagers around here.")
}
```

In Swift 4.1, there was no way to do the opposite and find the last element or index of the last element, so a similar set of API were introduced to provide this functionality. 

```
if let lastTeen = ages.last(where: { $0.hasSuffix("teen") }),
    let lastIndex = ages.lastIndex(where: { $0.hasSuffix("teen") }),
    let lastMajorIndex = ages.lastIndex(of: "eighteen") {
  print("Teenager number \(lastIndex + 1) is \(lastTeen) years old.")
  print("Teenager number \(lastMajorIndex + 1) isn't a minor anymore.")
} else {
  print("No teenagers around here.")
}
```
Here, along with some updated constant names, I've simply replaced "first" with "last" in the method calls - nothing like a nice balanced API!

Even though it's hard to believe, Swift 4.1 didn't have a way to check if all elements in a sequence satisfied a certain
condition.  Luckily Swift 4.2 introduced the allSatisfy method to Sequence that takes in a closure to check against each of the elements.  If I define an array of values, I can then use allSatisfy to check whether all the number are even

`let values = [10, 8, 12, 20]`
`let allEven = values.allSatisfy { $0 % 2 == 0 }`
`allEven`
Here, allSatisfy perfoms the code in the closure on each element of the array, making sure each element satisfies that check.  

# Outro

Swift 4.2 didn't give us ABI stability like some had hoped (that's coming in Swift 5) 
but it did include some really nice additions to improve the overall usefulness of the 
language.

Swift 4.1 had attributes to handle grabbing the first index of a certain element, or the 
first element that satisfied the condition - now those methods are a little clearer 
syntactically.  Swift 4.2 also added in some needed methods to grab the last index of 
an element or the last element that matches a given predicate
 
 That's a quick look at some of the improvements in Swift 4.2.  Continue to come back to 
 raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!
