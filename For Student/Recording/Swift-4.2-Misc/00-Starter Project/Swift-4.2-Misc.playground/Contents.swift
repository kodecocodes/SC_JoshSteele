import UIKit

//: The Hashable protocol has been updated with a hash(into:) method that takes care of the hashing, instead of you rolling your own hashing calculation.

class Country {
  let name: String
  let capital: String
  
  init(name: String, capital: String) {
    self.name = name
    self.capital = capital
  }
}

//:Now with the Country class fully adopting the Hashable protocol, instances of that class can be added into Sets and Dictionaries.  I can define a few countries and add them to a set and dictionary.

let france = Country(name: "France", capital: "Paris")
let germany = Country(name: "Germany", capital: "Berlin")
//let countries: Set = [france, germany]
//let countryGreetings = [france: "Bonjour", germany: "Guten Tag"]

// MARK: - Enumeration Cases Collection

//: I've got an Enum of the seasons here, as well as an enum of SeasonTypes, and I'm looping through them in a for loop.
//: Before CaseIterable, I had to explcitly define my cases before I loop - and that isn't good if the cases may change later in development.

enum Seasons: String {
  case spring = "Spring", summer = "Summer", autumn = "Autumn", winter = "Winter"
}

enum SeasonType {
  case equinox
  case solstice
}

//: Here allCases is automatically generated at runtime

let seasons = [Seasons.spring, .summer, .autumn, .winter]
for (index, season) in seasons.enumerated() {
  let seasonType = index % 2 == 0 ? SeasonType.equinox : .solstice
  print("\(season.rawValue) \(seasonType).")
}


//: You can also specify that only certain cases get returned by overriding allCases.  I've got an Enum of months here, and I only want to specify certain ones, and to do that I'll define my own allCases array

enum Months: CaseIterable {
  case january, february, march, april, may, june, july, august, september, october, november, december
  
  //override allCases here

}

//: Finally, you can even specify that cases with associated values get added - or not! - to the allCases array
enum BlogPost {
  case article
  case tutorial(updated: Bool)
  
  //add allCases here with allowed associated value entries, be sure to make CaseIterable
}

// MARK: - Removing Elements from Collections

//: Swift 4.2 now includes a removeAll method that takes in a closure, removing all elements from a Collection.  I have an array of things to say at the start or end of conversation.  If I want to keep things brief, I can remove all of the items whose length is greater than 3.



// MARK: - Toggling Boolean States

//: Finally, if I have a boolean in my code and I want to quickly change its state, all I have to do is call toggle() on the boolean

