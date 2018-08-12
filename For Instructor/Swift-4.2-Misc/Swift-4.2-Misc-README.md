# What's new in Swift 4.2 - Miscellaneous Changes


# Screencast Metadata

## Screencast Title

What's New in Swift 4.2 - Miscellaneous Changes

## Screencast Description

Swift 4.2 added a lot of polish that can affect your day-to-day coding.  This screencast covers some of them.   

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0 Beta 5 or greater
* **Editor**: Xcode 10.0 Beta 5 or greater


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  In this 
screencast, I'll go over some of the highlights in Swift 4.2, which was released 
alongside Xcode 10.

A few things before we get started.  As I mentioned - you'll need at least Xcode 10 beta 
or above to follow along with this screencast.  Also, I'd like to give a big thanks to 
Cosmin Pupaza, who wrote the What's New in Swift 4.2 tutorial, which is the basis for this 
screencast.

Swift 4.2 introduced a lot of small changes to add some polish to the language.  

For example, In Swift 4.1, when dealing with classes that supported hashing, you had to implement custom hash functions, defining your
own hash equation to generate a hashValue.  Now, in Swift 4.2, the Hashable protocol has a built in hash(into:) method, which also
provides a nice performance boost.

Let's take a look.


# DEMO

I've got a Country class here - let's make it adopt Hashable.  

```
//1 - have country adopy the Hashable protocol
class Country: Hashable {
  let name: String
  let capital: String

  init(name: String, capital: String) {
    self.name = name
    self.capital = capital
    }

  //2 - Add these - both are required
  static func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.name == rhs.name && lhs.capital == rhs.capital
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(capital)
  }
}
```

Now with the Country class fully adopting the Hashable protocol, instances of that class can
be added into Sets and Dictionaries.  I can define a few countries and add them to a set and dictionary.

```
let france = Country(name: "France", capital: "Paris")
let germany = Country(name: "Germany", capital: "Berlin")
let countries: Set = [france, germany]
let countryGreetings = [france: "Bonjour", germany: "Guten Tag"]
```

# Talking Head 2

While Enums are an important part of Swift, there wasn't a native way to get access to collections of enumeration cases - 
at least not until Swift 4.2.  This lack of native support usually involved making your own collection of the Enumeration cases 
everywhere you wanted to iterate over them, for example, which was great until you added another case to your Enum - and had to change
it in every single place in your code.  Now, the new CaseIterable protocol generates that collection for you.  Let's take a look.

# Demo 2

I've got an Enum of the seasons here, as well as an enum of SeasonTypes, and I'm looping through them in a for loop.  
However, I have to explcitly define my cases before I loop - and that isn't good if the cases may change later in development.  I'll adopt CaseIterable
to help make access to the cases easier.  

```
//1 - add case iterable 
enum Seasons: String, CaseIterable {
  case spring = "Spring", summer = "Summer", autumn = "Autumn", winter = "Winter"
}

enum SeasonType {
  case equinox
  case solstice
}

//2 - Remove this
let seasons = [Seasons.spring, .summer, .autumn, .winter]

//3 - change seasons to Seasons.allCases
for (index, season) in seasons.enumerated() {
  let seasonType = index % 2 == 0 ? SeasonType.equinox : .solstice
  print("\(season.rawValue) \(seasonType).")
}
```

Now, the allCases collection doesn't need to be specifically defined everytime I want it - instead, the system provides it for me. 

You can also specify that only certain cases get returned by overriding allCases.  I've got an Enum of months here, and I only
want to specify certain ones, and to do that I'll define my own allCases array

```
enum Months: CaseIterable {
  case january, february, march, april, may, june, july, august, september, october, november, december

  //4 - add this
  static var allCases: [Months] {
    return [.june, .july, .august]
  }
}
```
Here, I'm only concerned about the summer months, so I only include those in allCases

Finally, you can even specify that cases with associated values get added - or not! - to the allCases array

```
enum BlogPost: CaseIterable {
  case article
  case tutorial(updated: Bool)

  static var allCases: [BlogPost] {
    return [.article, .tutorial(updated: true), .tutorial(updated: false)]
    }
}
```
Here, I've allowed all types - articles as well as both existing and updated tutorials, as BlogPost types.  


# Talking Head 3

Finally, I'm going to show you a few pieces of syntactical sugar that are oh so sweet.  If you've ever tried to remove
elements from a collection that met a certain critera in Swift, you would have quickly found there wasn't a way to do that.  
And amazingly, there wasn't a way to toggle the state of a Boolean.  Swift 4.2 changes both of those - let's take a look.


# Demo 3

Swift 4.2 now includes a removeAll method that takes in a closure, removing all elements from a Collection.  I have an array 
of things to say at the start or end of conversation.  If I want to keep things brief, I can remove all of the items whose length is greater than 3.

```
var greetings = ["Hello", "Hi", "Goodbye", "Bye"]
greetings.removeAll { $0.count > 3 }
```

Finally, if I have a boolean in my code and I want to quickly change its state, all I have to do is call toggle() on the boolean

```
var isOn = true
isOn.toggle()
```



# Outro

Swift 4.2 didn't give us ABI stability like some had hoped (that's coming in Swift 5) 
but it did include some really nice additions to improve the overall usefulness of the 
language.

Not all changes to a language need to be big ones - sometimes a little syntactical 
sugar goes a long way towards making the language a little easier to use
 
 That's a quick look at some of the improvements in Swift 4.2.  Continue to come back to 
 raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!
