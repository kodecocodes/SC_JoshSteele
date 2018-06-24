# Screencast Metadata

## Screencast Title

Coordinators

## Screencast Description

A coordinator design pattern, which makes heavy use of delegates and protocols, allows you to let your UIViewControllers do what they are best at - displaying views!  Things like navigation, networking, and in this example, interaction with HealthKit, are all delegated to the coordinator.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.1
* **Platform:** iOS 11.3
* **Editor**: Xcode 9.3

# Script

## Introduction (Talking Head 1)

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  Have you ever noticed that some UIViewControllers - even some you may written yourself - seem to do way more than control the views?  Networking calls, Database management, App navigation, and more, can easily get stuffed into a UIViewController, which usually makes them hundreds of lines of code long, and very difficult to maintain since they have their hands in everything.  In this screencast, I'm going to show you an example of the Coordinator pattern, which makes heavy use of delegates and protocols to keep your UIViewControllers nice and small and doing what they were intended to do - control your views.  

The idea for this screencast was inspired by a series of blog posts by Dave DeLong (@davedelong), so please give Dave a follow if you like what you see here and want to learn more.  In this example, I'm going to setup some view controllers for a small helper app I've been working on to let me enter workouts and water consumption into HealthKit.  Before we look at the code, let's go over the general concept.   

In a typical delegate-protocol pattern, the object you are delegating responsibility to is very "aware" of your app - for example, a UITableViewDataSourceDelegate object knows how many rows should be in your table, passing that knowledge back to the UITableView.  In this example, the UIViewControllers will be delegating back to the Coordinator to determine, among other things, where to navigate to next.  Since the UIViewControllers don't need to worry about navigation anymore, they can focus on doing what they do best - controlling views. 

## Example 1

[Show start of CoordinatorViewController code]
Let's take a look at the project structure, since we're doing things a bit different from your normal project setup.  Here's my almost completed app.  The CoordinatorViewController is the Coordinator for this example, and I already have view controllers and xibs defined. 

[Zoom in on listing near LaunchScreen.xib - please do this in editing]
Speaking of which, you may have noticed there is no main storyboard in the project.  Since the coordinator is going to handle navigation, we don't need to worry about segues, so I'm going to just use xib files to layout the views for each UIViewController.   

[Show LandingPageViewController]
Each UIViewController subclass has a corresponding protocol that the CoordinatorViewController adopts, so it can pass requests for specific functionality back to the controller.  


## Talking Head 2

Now, I have my view controllers setup already in the project, and most of them are wired up, but I still need to add some code to the view controller that deals with entering the amount of calories burned during exercise, as well as the controller class so it gets wired in properly.  To do this, we'll use the Delegate-Protocol pattern.  

To wire up the viewcontrollers, you have to do 3 things: define the protocol, use the protocol methods in your view controller, and implement the methods in your delegate (the controller class in this example).  Let's walk through each of those.  


## Example 2

In our enter workout view controller, we need to define three responses to the users actions: asking for info about the workout screen, entering a successful workout entry, and entering an improper entry.  In the EnterWorkoutTimeViewController class, define a EnterWorkoutTimeViewControllerDelegate protocol

`
//1. Add this protocol
protocol EnterWorkoutTimeViewControllerDelegate: class
{
  func enterWorkoutInfo()
  func enterWorkoutSaveSuccessful(calories: Double)
  func enterWorkoutSaveFailed(message: String)
}
`

This declares the enterWorkoutInfo, enterWorkoutSaveSuccessful, and enterWorkoutSaveFailed methods, which we'll use further down in the file.    

Next, declare a delegate object of type EnterWorkoutTimeViewControllerDelegate in the EnterWorkoutTimeViewController class.  

`
//2. Declare the delegate
weak var delegate: EnterWorkoutTimeViewControllerDelegate?
`
This delegate will be used by the UIViewControllers to delegate actions it doesn't know enough about back to the controller.  

Now with the delegate declared, we can call methods on it elsewhere in our view controller.  If the user hasn't entered calories in the text field, or puts in an invalid value, call the delegate's enterWorkoutSaveFailed method with a message that goes with this error

`//2a. Let the delegate popup the alert with the given message
delegate?.enterWorkoutSaveFailed(message: WorkoutInputDataError.missingWorkoutCalories.localizedDescription)
`
`
//2b. Let the delegate popup the alert with the given message
delegate?.enterWorkoutSaveFailed(message: WorkoutInputDataError.invalidValue.localizedDescription)
`
This lets the delegate know the save failed so it can notify the user (note that we aren't saying how to alert the user, just that the save failed for a particular reason)

If the values is valid and taps the continue button, notify the delegate that the workout save was successful.  Again note that we're leaving what happens next to the coordinator, and not handling it here.  

`//2c. Let the delegate know the workout was successful
delegate?.enterWorkoutSaveSuccessful(calories: workoutCaloriesValue)    `

This passes the entered value to the coordinator, where it can decide what to do with it.  

Finally, if the user taps on the workout info button, notify the delegate.  

`//2d. Tell the delegate that the enter workout info button has been tapped
delegate?.enterWorkoutInfo()`

What does this do?  That's for the coordinator to determine, not this view controller.  So, let's add methods to implement the delegate back in the CoordinatorViewController.   

First, I'll define the extension, and implement the enterWorkoutInfo method

`//3. Add this extension to implement this delegate 
extension CoordinatorViewController: EnterWorkoutTimeViewControllerDelegate
{
  //3a. Display an alert if the info button is tapped
  func enterWorkoutInfo() {
    displayAlert(for: "Here, you can enter how many calories you burned during your workout.  Try to close those rings!")
  }
`
Here, I've decided to display an alert with a message if this method is called.  What you do here is up to you, and is totally disconnected from the workout view controller!

Next, I'll define the enterWorkoutSaveSuccessful method

`  //3b. If everything is valid, pass on the values to the review controller, and present it
  func enterWorkoutSaveSuccessful(calories: Double) {
    latestWorkoutCalories = calories
    reviewController.waterValue = latestWaterConsumed
    reviewController.caloriesValue = latestWorkoutCalories
    reviewController.waterUnit = latestWaterUnit.unitString
    presentVC(reviewController)
  }
`
This take in the calories passed into the method, the last water consumed, sets those values in the review controller , and displays it.  Think of this as `prepareForSegue` and the segue in an normal storyboard setup.  

Finally, define enterWorkoutSaveFailed

 ` //3c.  If the entry failed, display an alert with the passed in message
  func enterWorkoutSaveFailed(message: String) {
    displayAlert(for: message)
  }
}
`
Again, this simply shows an alert with the passed in message for this demo, but can be anything you can imagine to display the message to the user!

Now, I can build and run this on the simulator, and all of the functionality I just defined for the workout controller is place.  

## Conclusion

Working with this coordinator pattern is pretty different from how many iOS developers design their apps, but it definitely helps with maintenance of your code.  UIViewControllers become very simplified, and delegate their responsibilities back to the coordinator.  You can also develop your view controllers and their xibs very quickly, allowing you to get your app up and running, at which point you can focus on components like app navigation, networking, and more.  

Be sure to keep coming back to raywenderlich.com for more tutorials and screencasts about iOS development.  See you next time!


