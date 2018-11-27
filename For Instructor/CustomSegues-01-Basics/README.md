# Custom Segues - Basics


# Screencast Metadata

## Screencast Title

Custom Segues - Basics

## Screencast Description

In iOS 9, custom transitions got a nice upgrade with custom segues that let you separate your transition animation and view controller code.  This screecast goes over segue basics.    

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.1
* **Editor**: Xcode 10.1


# Script

Hey everyone, it's Josh, and it's probably a safe bet that you started watching this video right after doing something else - doing a little coding, brushing your teeth, going on a run - it really doesn't matter.  What DOES matter is that you performed your own version of a segue from one activity to another, one that was customized to fit with your current lifestyle.  

What you may NOT know is that when you move from one view controller to another in iOS, you do so by a segue that can contains custom transition animations, and with iOS 9, you can keep your animation code and view controller code nice and separated from one other, making it cleaner to read, and easier to maintain.  

In this screencast, we'll go over the basics of segues and using a custom segue in your app. Before we get started, I'd like to give a big thanks to Caroline Begbie, who wrote the Custom Segues chapter in iOS 9 by Tutorials, which is the basis for this screencast.  

For our demo, we'll be updating the segues in the PamperedPets app, a pet-minding app that when complete, will display a list of pets to mind and their details. 

In particular we'll add a segue to display a larger picture of the pet when the user taps on the image in the the detail screen.  Let me perform my own segue into the code, and show you how to add that transition now.   


#DEMO

Getting a basic segue up and running is pretty straightforward.  We want to kick off the segue when the picture is tapped, but currently there is no tap gesture recognizer on the picture - let's fix that.

[Drag a tap gesture recognizer to the picture]

Now, we need to connect the tap gesture recognizer to the Animal Photo View Controller in order to establish the segue.  To do this, control-drag from the tap gesture recognizer in the document outline to the animal photo view controller, and choose "present modally" when the popup menu appears.  You now have a segue!  

[Create the segue via ctrl-drag]

Let's give the segue the proper idenitifier so that the code recognizes it.  To do this, select the segue, and in the attributes inspector change the identifier to "PhotoDetail".

[Update the attributes of the segue]

In the code for AnimalDetailViewController class, let's use this idenitifer to setup the destination view controller in prepareForSegue:

```
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PhotoDetail" {
      let controller = segue.destination as! AnimalPhotoViewController
      controller.image = imageView.image
    }
  }

```

Here, you're telling the destination view controller the right image to display.  

If you run this on the simulator now, and tap the image, a larger version will appear, but you have no way to return to the detail view.  This can easily be remedied with the use of an exit segue.  Add the following code to AnimalDetailViewController:

```
  @IBAction func unwindToAnimalDetailViewController(_ segue:UIStoryboardSegue) {
    // placeholder for unwind segue
  }
```

This method - or more precisely - a method with this particular method signature, can be used as an anchor point for the end of an exit segue.  

To use that method, go to the Main storyboard, choose the AnimalPhotoViewController, and drag a tap gesture recognizer onto the Pet Photo view

[Drag the tap gesture recognizer]

Then, control-drag from the gesture recognizer in the outline to the "exit" entry, let go of the click, and when the popup appears, choose ` unwindToAnimalDetailViewController: `.  This tells the system that when the image is tapped, pop this view controller off the stack, and continue to do so until a class that contains `unwindToAnimalDetailViewController:` is encountered.  

Now if you run the app in the simulator, you can tap to get the full sized image, and then tap on the full sized image to the get the original view back, thanks to the exit segue.  

Finally, let's look at how easy it is to change segue types.  Go back and select the segue again, and in the attributes inspector, change the type to DropSegue, and rerun the app.  See how the segue has changed?

[Change the segue type, and rerun the app in the simulator, tapping on the photo and dismissing it]
 

#OUTRO

Segues have been around since iOS 5, and it's easy to setup segues - both forward and backward - and changing to a different type of segue - including custom ones - is as easy as updating a field in Interface Builder.  

That's a real quick look at the basics of segues and using custom segues in your app.  Now you're ready to move onto the next task in your day.  Ok, so control click drag from this video over to your next task to establish the segue, right, like that, now let go and choose "Show" - there ya go.  OK, you're all set.  When this video ends, you'll transition to the next thing in your day.  

Keep coming back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!  