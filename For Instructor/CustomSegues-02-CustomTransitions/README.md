# Custom Segues - Custom Transitions


# Screencast Metadata

## Screencast Title

Custom Segues: Custom Transitions

## Screencast Description

It's easy to make your own custom segue transition with the help of some protocols, as well as the newly introduced separation of view controller and transition code that was introduced in iOS 9.    

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.1
* **Editor**: Xcode 10.1


# Script

Hey everyone, it's Josh, and if you've been using iOS for a while like I have, you've probably seen a number of neat transitions animations over the years - some written by Apple, but other created be developers just like you.  

In this screencast, we'll go over how to make your own custom segue transitions.  Before we get started, I'd like to give a big thanks to Caroline Begbie, who wrote the Custom Segues chapter in iOS 9 by Tutorials, which is the basis for this screencast.  

For our demo, we'll be updating the segues in the PamperedPets app, a pet-minding app that when complete, will display a list of pets to mind and their details. 

In particular we'll make a new custom segue - ones that scales an images - using a good dose of protocols to accomplish the task, in particular: 

UIViewControllerTransitioningDelegate, which vends the animator objects upon presentation and dismissal of the view controller, UIViewControllerAnimatedTransitioning, which describes the animations, and UIViewControllerContextTransitioning, which holds details about the presenting AND presented view controllers and views.  Let's see how each of those are used as we "scale" the size of our fish.

#DEMO

## Subclassing UIStoryboardSegue

First, let's make a new UIStoryboardSegue subclass, which will adopt the UIViewControllerTransitionDelegate, allowing us to specify a custom transition animation later on.  Make the ScaleSegue class and then define an extension below it to handle the protocol.  

```
class ScaleSegue: UIStoryboardSegue {

}

extension ScaleSegue: UIViewControllerTransitioningDelegate {

}

```

This protocol lets the segue vend presentation and dismissal animators for use in the transitions.  Later, we'll implement a protocol method that returns the custom animator we'll build.  

For now, override the `perform` method in `ScaleSegue` as follows:

```
  override func perform() {
    destination.transitioningDelegate = self
    super.perform()
  }

```

Here, the transitioning delegate of the destination of the segue is set, so that the ScaleSegue class is in charge of vending animator objects.  In previous iOS versions, you may have put the transition animation code in `perform` but now you can use this transitioning delegate to decouple the animation from the segue.  


## Create the presenting and dismissing animator classes

Next, let's create the animator.  Inside the ScaleSegue.swift class, make a new class called ScalePresentAnimator, which extends NSObject and adopts the UIViewControllerAnimatedTransitioning.  

```
class ScalePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

}
```

We'll use this to present the modal view controller.  Note that I'm keeping the animators in the same file as its segue, since they're closely related, but they can be kept in separate files if desired.  

## Define the animation and its duration to be used in animators

Now let's define the important code for this demo, and that is the code related to the transition itself.  Add the `transitionDuration` method to ScalePresentAnimator

```
func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 2.0
}
```

The duration here is 2 seconds which is bigger than a normal transition of 0.5 second or so; this is done to let you see the effect cleary.  Now, for the actual transition, add the method called `animateTransition`

```
func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // 1. Get the transition context to- controller and view
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)

    // 2. Add the to- view to the transition context
    if let toView = toView {
      transitionContext.containerView.addSubview(toView)
    }
    
    // 3. Set up the initial state for the animation
    toView?.frame = .zero
    toView?.layoutIfNeeded()
    
    // 4. Perform the animation
    let duration = transitionDuration(using: transitionContext)
    let finalFrame = transitionContext.finalFrame(for: toViewController)
    
    UIView.animate(withDuration: duration, animations: {
      toView?.frame = finalFrame
      toView?.layoutIfNeeded()
      }, completion: {
        finished in
        // 5. Clean up the transition context
        transitionContext.completeTransition(true)
    })
  }
```
This is a little involved, so let's break this down.  First, we've grabbed the "to" viewcontroller and views from the transitionContext.  Second, if the destination view isn't nil, add it to the transitionContext's containerView so it can be presented.  Third, define the inital frame and lay it out.  Fourth, get the duration for this transition and the final frame for the transition so that finally, we can perform the animation with the given transition, setting the final frame as the destination for the animation and calling "completeTransition" on the transition Context.  


## Instruct the segue which animator classes to use

Now let's add a delegate method to `ScaleSegue`s  `UIViewControllerTransitionDelegate` extension:

```
 func animationController(forPresented presented: UIViewController,
     presenting: UIViewController,
     source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScalePresentAnimator()
 }
```

This simply tells the segue to use the ScalePresentAnimator during presentation

## Use the segue in the storyboard

Finally, to tie the code to storyboard, set the segue class type to `Scale Segue` and change the presentation type to `Form Sheet`. Now, if you run the app in the phone simulator, and tap on the image, it will take up the full screen, and if you run it on the iPad, it will scale up into a form sheet.  

## Passing data to animators

Let's look at one more thing - most users would expect the small photo to scale directly to a large one - but how do you tell the animator which view to scale?  You don't have a direct reference to the source image view since everything is decoupled.  Protocols are a great tool to use in this situation.  The animal detail view controller can adopt a protocol to set which view to scale.  The animator can then use that protocol's scaling without knowing anything about the source.

```
protocol ViewScaleable {
  var scaleView:UIView { get }
}
```

If we make AnimalDetailViewController adopt this protocol, and give it a scaleView property, we'll be set.  

```
extension AnimalDetailViewController: ViewScaleable {
  var scaleView:UIView { return imageView }
}
```

Now let's use this in our transition code.  In `ScaleSegue`'s `animateTransition` method, find the code that starts with `let toViewController` and before that line, add the following

```
var fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)

```

This gets references for the "from" viewcontroller and view.  Be sure to use the proper enums here - it is very easy to get them confused!

Next, replace `toView?.frame = .zero` with 

```
var startFrame = CGRect.zero
if let fromViewController = fromViewController as? ViewScaleable {
  startFrame = fromViewController.scaleView.frame
} else {
  print("Warning: Controller \(fromViewController) does not conform to ViewScaleable")
}
toView?.frame = startFrame
```
 
Instead of starting the "to" frame at the top left, this starts the animation at the "from" view controller's scaleView frame property, assuming that view controller adopts `ViewScalable`

Keep in mind here that the animator knows nothing about the source view controller, just that it adopts ViewScalable - a beautiful decoupled software design.  

If you run this in the phone simulator again, you'll see that the image scales as one might expect.  


#OUTRO

The built in capabilities of iOS continue to be extraordinary, but to have them represent your app just how you want, protocols are used to fill in some of the functionality gaps.  This is no different for defining your own custom segue transitions.  Animations descriptions, controller and view details and the vending of the animation objects are all defined by objects that adopt specific protocols, unique to your app.  

That's a look at how to make a custom segue transition in your app.   

Keep coming back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!  
