# Custom Segues - Dealing with Size Classes


# Screencast Metadata

## Screencast Title

Custom Segues - Dealing with Size Classes

## Screencast Description

Custom segues have slightly different behavior if they are used with different size classes, as well as if they are used in embedded view controllers - this screencasts discusses how to deal with both situations.   

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.1
* **Editor**: Xcode 10.1


# Script

Hey everyone, it's Josh, and for years, Apple has been pushing the idea of using size classes - allowing you to handle what has become a large number of different screen sizes across various devices - without having to duplicate your code over and over again for each screen resolutions.  

When you work with size classes, there are a few things that you have to watch out for, and how you define your custom segue transitions is one of them.  Before we get started, I'd like to give a big thanks to Caroline Begbie, who wrote the Custom Segues chapter in iOS 9 by Tutorials, which is the basis for this screencast.  

For our demo, we'll be updating the segues in the PamperedPets app, a pet-minding app that when complete, will display a list of pets to mind and their details. 

In particular we'll look at the differences in the transition when working with an iPad (and iPhone plus in landscape) versus a device like an iPhone 8.  In particular, the transition context handles presentations differently based on the size class - the modal form for a horizontal, regular-sized display is wrapped in a presentation layer that provides a dimming view and rounds the corners of the form sheet; the modal controller on a compact display, however, takes up the full screen.  Let's take a look at how that changes the segue, and how we can make it a little better looking.


#DEMO

If I find the line in `animateTransition` in the ScaleSegue class that sets the `toView` property, I can replace it with the toViewController's view property

```
let toView = toViewController.view
```

If I run this in the phone simulator, things look ok - but on an iPad similar, the form sheet scales in from the top left and looks very weird.

[Run in simulator]

In a similar fashion, the transition context's "from" view could be different from the source view controller's view - in compact views, they are identical, but in normal sized views "from" would be nil.  Let's see if we can take advantage of that behaviour in our code to make things look a bit better.  

Restore the code to the previous state.

```
let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
```

In the animation block near the end of `animateTransition`, add in some code to fade out the `from` View

```
fromView?.alpha = 0.0
```

Then, after the call to `completeTransition`, add in some code to fade the view back in

```
fromView?.alpha = 1.0
```

If I run this in the iPhone simulator, you can see the from view fade away as the animation takes place.  In the iPad however, the presentation layer handles the fading of the background so our `fromView` property is nil

# Script

There's one more thing we can look at - up to this point, we've been looking at the individual detail views in the table, but what if we run the app and have our detail views from the UITableView?  Let's take a look.

# DEMO 

I can change the initial view controller to the NavigationController instead of the Animal Detail View Controller by tweaking that attribute in the Attributes Inspector.

[Change initial view controller to Navigation Controller]

If I run the app in the phone simulator now, the animation scales up from the wrong spot!  This is because the presenting view - which is now the navigation controller - does not conform to the ViewScalable protocol, which means it can't tell the segue what the view to animate is.  

This can easily be fixed by adding a check to the code.  At the beginning of the `animateTransition` method in ScaleSegue.swift, add the following code to the top of the method, replacing the code that sets the fromViewController with the following:

```
var fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
if let fromNC = fromViewController as? UINavigationController {
  if let controller = fromNC.topViewController {
    fromViewController = controller
  }
}
```
Here this replaces the fromViewController only if the presenting view controller is a navigation controller.  Run this in the simulator to see that the animation takes place from the proper location

#OUTRO

If you're going to support multiple devices nowadays, screen sizes are a must if you want easily maintanable code.  If you have a custom segue transition in your app on top of using multiple size classes, you need to make sure that you tweak your transitions to handle the slight differences in how the views are presented between the size classes.  

That's a quick look at how to deal with size classes when working with custom segue transitions.  

Keep coming back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time! 



 