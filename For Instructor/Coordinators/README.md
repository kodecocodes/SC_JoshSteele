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

Hi everyone, this is Josh.  Have you ever noticed that some UIViewControllers - even some you may written yourself - seem to do way more than control the views?  Networking calls, Database management, App navigation, and more, can easily get stuffed into a UIViewController, which usually makes them hundreds of lines of code long, and very difficult to maintain since they have their hands in everything.  In this screencast, I'm going to show you an example of the Coordinator pattern, which makes heavy use of delegates and protocols to keep your UIViewControllers nice and small and doing what they were intended to do - control your views.  The idea for this screencast was inspired by a series of blog posts by Dave DeLong (@davedelong), so please give Dave a follow if you like what you see here and want to learn more.  In this example, I'm going to setup some view controllers for a small helper app I've been working on to let me enter workouts and water consumption into HealthKit.  Before we look at the code, let's go over the general concept.   In a typical delegate-protocol pattern, the object you are delegating responsibility to is very "aware" of your app - for example, a UITableViewDataSourceDelegate object knows how many rows should be in your table, passing that knowledge back to the UITableView.  In this example, the UIViewControllers will be delegating back to the Coordinator to determine, among other things, where to navigate to next.  Since the UIViewControllers don't need to worry about navigation anymore, they can focus on doing what they do best - controlling views.  Let's take a look.  

## Example 1

Here's the starter project for my app.  A few things to note - first, there is some existing HealthKit example code already in the project so there is no need to implement that for this example.  Second, I've already added a CoordinatorViewController, which will be the Coordinator for this example. Finally, you may have noticed there is no main storyboard in the project.  Since the coordinator is going to handle navigation, we don't need to worry about segues, so I'm going to just use xib files to layout the views for each UIViewController.  

To help with the navigation, I'm going to add some code, via an extension on UIViewController, to help manage the adding and displaying of new view controllers.  

func presentVC(_ viewController: UIViewController)
{
  let duration = 0.3
  addChildViewController(child)

  let newView = child.view!
  newView.translatesAutoresizingMaskIntoConstraints = true
  newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  newView.frame = view.bounds

  view.addSubview(newView)
  UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve], animations: { }, completion: { done in
  child.didMove(toParentViewController: self)
  completion?(done)
  })
}

The presentVC method will take a in a view controller, and add it as a child view controller.  We can adjust some of the properties of that view controller's view - namely the translatesAutoresizingMaskIntoConstraints to true and the autoresizing mask to be flexible width and flexible height.  The frame for that view can then be set to the current view's bound so it fills the screen.  


## Talking Head 2



## Example 2








