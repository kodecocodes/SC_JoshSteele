import UIKit

// MARK: - Dynamic Member Lookup

//: In Swift 4.1, custom subscript calls to get dynamic members used a square bracket syntax, provided by a subscript method on the class.  In Swift 4.2, you can update the class quickly to support dynamic member lookup

// 1 - Add attribute
@dynamicMemberLookup
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
  subscript(dynamicMember key: String) -> String {
    switch key {
    case "info":
      return "\(name) is \(age) years old."
    default:
      return details[key] ?? ""
    }
  }
}

//: This allows access to the info and title properties by dot syntax, and doesn't change the access to the name and age properties

let details = ["title": "Author", "instrument": "Guitar"]
let me = Person(name: "Cosmin", age: 32, details: details)
//me["info"]    //this was the old Swift 4.1 access
//me["title"]   //this was the old Swift 4.1 access
me.info
me.title
me.name
me.age

//: Child classes also get access to their parent's dynamic member lookup capabilities.  For example, if I have a `Vehicle` class defined, I can define a `Car` class that inherits from it.

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

//3 - declare `Car`
class Car: Vehicle {}

let car = Car(brand: "BMW", year: 2018)
car.info

//: You can also add dynamic member lookup to protocols via protocol extensions.  If I have a `Random` protocol, I can extend it to include a `subscript(dynamicMember:)` method that provides the dynamic member lookup capability, returning a number between 0 and 9

@dynamicMemberLookup
protocol Random {}

extension Random {
  subscript(dynamicMember key: String) -> Int {
    return Int.random(in: 0..<10)
  }
}

//: I can then extend `Int` to give that type the new functionality.
extension Int: Random {}

//: Finally, I can use the dot syntax to generate a random number, convert it to a string, and filter it out from the string version of the original number

let number = 10
let randomDigit = String(number.digit)
let noRandomDigit = String(number).filter{String($0) != randomDigit}
