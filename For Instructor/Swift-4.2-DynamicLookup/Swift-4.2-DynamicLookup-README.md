# What's new in Swift 4.2 - Dynamic Member Lookup


# Screencast Metadata

## Screencast Title

What's New in Swift 4.2 - Dynamic Member Lookup

## Screencast Description

Swift 4.2 added a new easy to use dynamic member lookup attribute to give your classes dot syntax access for custom subscript calls.  

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

Swift 4.2 added dynamic member lookup to provide dot syntax for dynamic property lookups 
instead of using square brackets.  Let's take a look.


# DEMO

In Swift 4.1, custom subscript calls to access dynamic members, used a square bracket syntax, provided 
by a subscript method on the class, as seen here.  In Swift 4.2, you can update the class quickly to support 
dynamic member lookup and get those same dynamic members by dot notation. 

//NOTE: Have from here to the example written, add 1 and 2, and then rerun the playground to show things improve

First, I'll add the @dynamicMemberLookup attribute to my class.  

Then, I'll prepend the key argument of subscript with dynamicMember

```
// 1 - Add attribute
//@dynamicMemberLookup
class Person {
  let name: String
  let age: Int
  private let details: [String: String]

  init(name: String, age: Int, details: [String: String]) {
    self.name = name
    self.age = age
    self.details = details
  }

  //2 - add subscript(dynamicMember:)
  subscript(/*dynamicMember*/ key: String) -> String {
    switch key {
      case "info":
        return "\(name) is \(age) years old."
      default:
        return details[key] ?? ""
    }
  }
}

//: This allows access to the info and title properties by dot syntax.

let details = ["title": "Author", "instrument": "Guitar"]
let me = Person(name: "Cosmin", age: 32, details: details)
me["info"]
me["title"]
//3 - call these
me.info
me.title
me.name
me.age
```

This allows you to switch from bracket syntax to dot syntax for accessing the info and title properties.  Note that this does not impact accessing the name
and age properties.  

Child classes also get access to their parent's dynamic member lookup capabilities.  For example, if I have a vehicle class defined, I can define a Car class that inherits from it.

```
@dynamicMemberLookup
class Vehicle {
  let brand: String
  let year: Int

  init(brand: String, year: Int) {
    self.brand = brand
    self.year = year
  }

  subscript(dynamicMember key: String) -> String {
    return "\(brand) made in \(year)."
  }
}

//3 - declare Car
class Car: Vehicle {}

let car = Car(brand: "BMW", year: 2018)
car.info
```

Even though not explicitly defined in the Car type, the info property is available from the dynamic member lookup defined by the parent Vehicle class.  


You can also add dynamic member lookup to protocols via protocol extensions.  If I have a Random protocol, I can extend it to include a subscript(dynamicMember:) method that provides the dynamic member lookup capability, returning a number between 0 and 9

```
@dynamicMemberLookup
protocol Random {}

extension Random {
  subscript(dynamicMember key: String) -> Int {
    return Int.random(in: 0..<10)
  }
}
```

 I can then extend `Int` to give that type the new functionality.
`extension Int: Random {}`

Finally, I can use the dot syntax to generate a random number, convert it to a string, and filter it out from the string version of the original number

```
let number = 10
let randomDigit = String(number.digit)
let noRandomDigit = String(number).filter{String($0) != randomDigit}
```

# Outro

Swift 4.2 didn't give us ABI stability like some had hoped (that's coming in Swift 5) 
but it did include some really nice additions to improve the overall usefulness of the 
language.

Before Swift 4.2, to make custom subscript calls, you had to use square bracket syntax.  
Now with a @dynamicMemberLookup attribute on your classes, and a small update to the
subscript method, you can easily provide dot syntax to get access to your dynamic properties.
 
 That's a quick look at some of the improvements in Swift 4.2.  Continue to come back to 
 raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!
