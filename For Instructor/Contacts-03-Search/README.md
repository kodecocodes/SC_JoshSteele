# Contacts - Searching Contacts


# Screencast Metadata

## Screencast Title

Contacts - Searching Contacts

## Screencast Description

The Contacts framework in iOS 9 supports predicates for easy searching of your Contacts list.      

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0
* **Editor**: Xcode 10.0


# Script

Hey everyone, it's Josh, and I'm back with another screencast here at raywenderlich.com, and this time we're talking Contacts, and in particular the Contacts Framework in iOS, which got some major overhauls in iOS 9.  In iOS 8, you needed to use a C API and ancient structs, but that got deprecated along with the Address Book framework in iOS 9.  In its place, the Contacts and ContactsUI frameworks got added.  

In this screencast, we'll go over how to use predicates to search your contacts list. Before we get started, I'd like to give a big thanks to Evan Dekhayser, who wrote the Contacts chapter in iOS 9 by Tutorials, which is the basis for this screencast.  

For our demo, we'll be creating RWConnect, the end all, be all, of social networks for iOS developers.  As with all social networks, it has a friends list to help you keep in touch with the developers you know via email.  

Before adding a new contact, we'll search the existing Contacts store with the help of a predicate - a term you may be familar with if you've ever worked with Core Data before. Predicates are essentially logical statements that evaluate to a boolean - either true or false.  Examples of logical statements that make up predicates are like "firstName == Josh" or "age == 43".  The NSPredicate class can both create predicates from a string, and also evaluate its predicate. 

OK, now with a quick refresher of NSPredicate in our minds, let's go over how to search your existing contacts so you can make sure duplicates don't appear in your list!


#DEMO

At the beginning of `saveFriendsToContacts` inside the `FriendsViewController` class, let's add some code to check for existing entries in the contacts store.  

First, create an instance of CNContactFormatter

```
//1
let contactFormatter = CNContactFormatter()
```
This formatter object provides locale-aware display names from our contacts, much as NSFormatter does with dates.  

Next, use the formatter to get the display name of the friend's contactValue property, which is the CNContact version of the data in the Friend struct.   

```
//2
let contactName = contactFormatter
  .stringFromContact(friend.contactValue)!
```

We'll use this name as the predicate for the search we'll perform later on.  That predicate can be set by using `CNContact`'s `predicateForContactsMatchingName` method.  

```
//3
let predicateForMatchingName = CNContact
  .predicateForContactsMatchingName(contactName)
```

To get the contacts - if any - that exist in the store and match this predicate, call `unifiedContactsMatchingPredicate` on the `CNContactStore`, passing in the predicate we created earlier.  We don't need to worry about fetching keys so we'll leave that array empty.   

```
//4
let matchingContacts = try! CNContactStore()
  .unifiedContactsMatchingPredicate(predicateForMatchingName,
    keysToFetch: [])
```

Our desire is to have the number of matching contacts come back as zero, but in case it doesn't, alert the user that the contact already exists via a `UIAlertAction`.  

```
//5
 guard matchingContacts.isEmpty else {
      DispatchQueue.main.async{
        let alert = UIAlertController(title:"Contact Already Exists", message:nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
      return
    }
```

Since we placed this code at the start of the `saveFriendsToContacts` method, the save will only succeed if the guard clause succeeds - if the else block gets invoked, the method returns and the save never gets a chance to take place. 

If we run this in the simulator, and try to add a friend that we've already added to the Contacts store, the alert telling us so pops up, meaning that our predicate had a successful match on the Contacts store.   


#OUTRO

The Contacts and ContactsUI frameworks that were added to iOS 9 made working with contacts a whole lot easier than in previous iOS versions.  No one wants duplicate contacts to show up when adding new entries, so CNContactFormatter helps you build a NSPredicate that can be used with the CNContactStore to let you easily search your existing contact list.    

That's a quick look at how to search your contacts store with a predicate.  Speaking of which, am I in your contact list?  Go ahead and search, I'll wait.  Make sure you get the E on the end of my name.  There you go.  OK great!

Keep coming back to raywenderlich.com for more tutorials and screencasts on iOS development.   See you next time!  