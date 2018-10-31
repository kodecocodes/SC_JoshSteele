# Contacts - Saving Contacts


# Screencast Metadata

## Screencast Title

Contacts - Saving Contacts

## Screencast Description

In iOS 9, the Contacts framework was introduced, providing a nice API for adding new contacts.    

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0
* **Editor**: Xcode 10.0


# Script

Hey everyone, it's Josh, and I'm back with another screencast here at raywenderlich.com, and this time we're talking Contacts, and in particular the Contacts Framework in iOS, which got some major overhauls in iOS 9.  In iOS 8, you needed to use a C API and ancient structs, but that got deprecated along with the Address Book framework in iOS 9.  In its place, the Contacts and ContactsUI frameworks got added.  

In this screencast, we'll go over adding new contacts to your devices' Contact store. Before we get started, I'd like to give a big thanks to Evan Dekhayser, who wrote the Contacts chapter in iOS 9 by Tutorials, which is the basis for this screencast.  

For our demo, we'll be creating RWConnect, the end all, be all, of social networks for iOS developers.  As with all social networks, it has a friends list to help you keep in touch with the developers you know via email.  

When we want to add new contacts, your app needs to access private user data - in this case, the Contacts store.  As with other private data access in iOS, you need to be sure to ask the user for permission, which also requires having an entry in your Info.plist file explaining WHY you need that access.  Without that, you won't be able to access the store.   

In this screencast - once we've taken care of asking for permission to access the Contacts store - we'll do 2 things.  First, we'll make our rows in the table have an action for adding that friend to our contacts, and second, actually perform the calls to save the new contact to the store.  

Ok, in its current state, I an see my friend's contact information in a very familar contacts UI, and I can also import current contacts into RWConnect - but what if I want to go the other way, and move a friend from RWConnect into my Contacts?  Let's go over how to add a new contact to the contact store. 

#DEMO

To begin, let's enable the rows in our table to show an action when the user slides left.  Define the `tableView:editActionsForRowAt` method, and declare a UITableViewRowAction that will present a "Create Contact" button.  The action for this button will be to request access to the contact store - at least initially.  We'll add more shortly.

```
override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let createContact = UITableViewRowAction(style: .normal, title: "Create Contact") { rowAction, indexPath in
      tableView.setEditing(false, animated: true)
      let contactStore = CNContactStore()
      contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { userGrantedAccess, _ in


      })
    }
    createContact.backgroundColor = BlueColor
    return [createContact]
  }
```

If `userGrantedAccess` is returned as false from the `requestAccess` method, present a permission error alert

```
	guard userGrantedAccess else {
	  self.presentPermissionErrorAlert()
	  return
	}
```
        
Otherwise, grab the selected friend for the given indexPath row, and pass it to the saveFriendToContacts method.  

```
	let friend = self.friendsList[indexPath.row]
   self.saveFriendToContacts(friend)
```

Now let's define the saveFriendToContacts method. First, get a mutable copy of the friend's contactValue property, becaus one of the methods we'll use below requires a mutable instance of the CNContact.  

```
//1
let contact = friend.contactValue.mutableCopy() as! CNMutableContact
```

Then, create an instance of `CNSaveRequest`.  This can communicate new, updated, or deleted contacts to the CNContactStore

```
//2
let saveRequest = CNSaveRequest()
```

Next, add the contact to the saveRequest, passing in nil to the container identifier.  


```
//3
saveRequest.add(contact, toContainerWithIdentifier: nil)
```

Finally, in the do/catch block, get an instance of the CNContactStore(), and execute the save request on it with the store's `execute` method.  The code in the do/catch block will handle both the success and failure cases, either presenting a success alert, or a failure alert, as the case may be.  

```
do {
  //4
  let contactStore = CNContactStore()
  try contactStore.execute(saveRequest)
  // Show success alert
  DispatchQueue.main.async{
    let successAlert = UIAlertController(title: "Contact Saved", message: nil, preferredStyle: .alert)
    successAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.present(successAlert, animated: true, completion: nil)
  }
} catch {
  // Show failure alert
  DispatchQueue.main.async{
    let failureAlert = UIAlertController(title: "Could Not Save Contact", message: "An unknown error occurred", preferredStyle: .alert)
    failureAlert.addAction(UIAlertAction(title:"OK", style: .cancel, handler: nil))
    self.present(failureAlert, animated: true, completion: nil)
  }
}
```

If we run this in the simulator, slide one of the friend rows to the left, and add a contact.  This should succeed, and just to confirm, you can go to the Contacts app on the simulator to see your new entry added.   

#OUTRO

The Contacts and ContactsUI frameworks that were added to iOS 9 made working with contacts a whole lot easier than in previous iOS versions.  After you've received permission from the user to access the Contacts store, CNSaveRequest allows you to prep a contact for delivery to the store, and when ready, the store can execute that request, saving your new contact, so you can access it again in the future.

Let's see, how could you test this new functionality?  Maybe add in the contact information for a smooth talking, handsome iOS screencaster..... what, no, I don't mean Brian!  No, not Spiro!  Ok, fine, go test with whomever you want....  

That's a quick look at how to save contacts to the Contacts store.  Keep coming back to raywenderlich.com for more tutorials and screencasts on iOS development.   See you next time!  