# Contacts - Displaying Contacts


# Screencast Metadata

## Screencast Title

Contacts - Displaying Contacts

## Screencast Description

In iOS 9, the Contacts and ContactsUI frameworks brought a nice set of APIs to developers to create contacts, and display and pick from their existing contacts.   

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0
* **Editor**: Xcode 10.0


# Script

Hey everyone, it's Josh, and I'm back with another screencast here at raywenderlich.com, and this time we're talking Contacts, and in particular the Contacts Framework in iOS, which got some major overhauls in iOS 9.  In iOS 8, you needed to use a C API and ancient structs, but that got deprecated along with the Address Book framework in iOS 9.  In its place, the Contacts and ContactsUI frameworks got added.  

In this screencast, we'll go over displaying and selecting contacts in your app. Before we get started, I'd like to give a big thanks to Evan Dekhayser, who wrote the Contacts chapter in iOS 9 by Tutorials, which is the basis for this screencast.  

For our demo, we'll be creating RWConnect, the end all, be all, of social networks for iOS developers.  As with all social networks, it has a friends list to help you keep in touch with the developers you know via email.  

We've got a version of RWConnect up and running, but it's missing the ability to connect to the Contacts store on the device.  To remedy that we'll need to 3 things.  First, build a CNContact from the information provided in the app's Friend struct.  Second, be able to display that contact on screen, using the native UI elements everyone is familar with from using the Contacts app.  And finally, we'll need to be able to bring contacts in from our existing Contacts store and add them to RWConnect, which means we'll need a way to pick them from the current Contacts list.  

With that battle plan in mind, let's dive into the code, and connect RWConnect to our Contacts!


#DEMO

RWConnect is in pretty good shape, but we need to move information that is currently in the Friend structs in the contacts store.  

To do all of this however, we'll need to import Contacts and ContactsUI at the top of the file, so let's go ahead and do that.

`import Contacts`

`import ContactsUI`

The first step in doing this is to convert that information to a CNContact object.  Let's make an extension on the `Friend` class, and declare the computed property `contactValue` which will build the `CNContact` object from the information in the `Friend` struct.  

Declare the CNContact var, and start off by making a CNMutableContact object - this will let us populate the fields for the contact. 

```
extension Friend {
  var contactValue : CNContact {
    //1
    let contact = CNMutableContact()
```
Next, set the contact's given name and family name

```
    //2
    contact.givenName = firstName
    contact.familyName = lastName
```

Next, set the email addresses array.  To do this, we'll use create a `CNLabeledValue` object, which takes in 2 arguments - the first is the label designating the email we want to use - remember, users may have more than one email address!  The second argument is the work email, cast as an NSString, which is required for the CNLabeledValue class.  

```
    //3
    contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: workEmail as NSString)]
```

Then, set the profile picture for the contact, if one exists in the `Friend` struct.  

```
    //4
    if let profilePicture = profilePicture {
      let imageData = profilePicture.jpegData(compressionQuality: 1)
      contact.imageData = imageData
    }
```

Finally, return a immutable copy of the `CNContact` using the `copy` method.

```
    //5
    return contact.copy() as! CNContact
  }
```

Next, let's allow the user to view a contact in the app.  In the FriendsViewController table view delegate extension, grab the currently selected friend from the friendsList, and then use the computed property we defined earlier to make a contact.  

```
	//1
    let friend = friendsList[indexPath.row]
    let contact = friend.contactValue
```
Now, create a CNContactViewController, using the forUnknownContact initializier, since the contact being shown is not part of the contacts store.  
    
```
    //2
    let contactViewController = CNContactViewController(forUnknownContact: contact)
    contactViewController.navigationItem.title = "Profile"
    contactViewController.hidesBottomBarWhenPushed = true
```

Next, disallow editing and actions on the view controller

```
    //3
    contactViewController.allowsEditing = false
    contactViewController.allowsActions = false
```
Finally, push the view controller onto the navigation controller

```
    //4
    navigationController?.pushViewController(contactViewController, animated: true)
```

If we run this in the simulator, we can get more information on our RWConnect friends, but view them in the UI we're used to from the Contacts app.  


Finally, if we want to import friends from our contact list, we can add some code to `addFriends` in `FriendsViewController`

```
	let contactPicker = CNContactPickerViewController()
    present(contactPicker, animated: true, completion: nil)
``` 

If we were to run this now, we'd be able to see the contacts, but we wouldn't be able to select them and add them to our friends list.  To fix that, we need to do 2 things - first, let's make an init method in the Friend class that takes in a CNContact

```
init(contact:CNContact) {
 firstName = contact.givenName
 lastName = contact.familyName
 workEmail = contact.emailAddresses.first!.value as String
 if let imageData = contact.imageData {
   profilePicture = UIImage(data: imageData)
 } else {
   profilePicture = nil
 }
}
```


Next, `FriendsViewController` needs to conform to CNContactPickerDelegate, and that can be done with an extenstion:

```
extension FriendsViewController : CNContactPickerDelegate {
  func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
    let newFriends = contacts.map { Friend(contact:$0) }
    for friend in newFriends {
      if !friendsList.contains(friend) {
        friendsList.append(friend)
      }
    }
    tableView.reloadData()
  }
}
```

Here, we're grabbing the picked contact (if one was picked), and building a Friend struct out of it.  Then, if that friend doesn't already exist in the app, it gets appended to the `friendsList`.  The table view also gets reloaded in case new data was added.  

Finally, don't forget to set the contact pickers' delegate to self.  Also, we want to make sure we only enable the selection of contacts that have email addresses, so we set a predicate via the contact picker's `predicateForEnablingContact` method.  

```
    contactPicker.delegate = self
    contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
```

#OUTRO

The Contacts and ContactsUI frameworks that were added to iOS 9 made working with contacts a whole lot easier than in previous iOS versions.  Mutable and Immutable Contact classes allow you to create your own Contact objects, and CNContactViewController shows your contact in the look and feel everyone is used to from the Contacts app.  Not only that, but when you want to pick from your current set of contacts, CNContactPickerViewController presents another familar interface from the Contacts app with a simple API call.  

Let's see, who do I have on my list here..... Brian, yep, he's pretty good, Darren...Keegan....and some guy named Ray?  He looks pretty experienced... maybe he should start a website or something....

That's a quick look at how to make, display, and pick contacts.  Keep coming back to raywenderlich.com for more tutorials and screencasts on iOS development.   See you next time!  