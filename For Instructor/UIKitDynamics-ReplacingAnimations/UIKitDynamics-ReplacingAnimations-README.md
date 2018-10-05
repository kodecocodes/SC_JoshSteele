# UIKit Dynamics - Replacing Animations


# Screencast Metadata

## Screencast Title

UIKit Dynamics - Replacing Animations

## Screencast Description

Behaviors in UIKit Dynamics can be used to replace UIView animations, giving you finer and more realistic control of the behavior of your views.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0
* **Editor**: Xcode 10.0


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  In this 
screencast, I'll go over how you can use UIKit Behaviors to replace UIView animations in your app.  

Before we get started, I'd like to give a big thanks to Aaron Douglas, who wrote the UIKit Dynamics chapter in iOS 9 by Tutorials,  which is the basis for this screen cast.

UIKit Dynamics is a 2D physics inspired animation system with a high level API, allowing you to simulate physics experiences in your animations and view interactions.  iOS 9 included new behaviors such as gravity fields, non-rectangular collision bounds and additional attachment behaviors.  

Before we get into some code, let's go over a few terms: Dynamic Behaviors encapsulate the physics for a particular effect like gravity, attraction or bounce.  Dynamic animators keep track of where all of your items are during the animation process.  Animators take in a reference view, and all of the subviews you animate must be subviews of the reference view.  

The amount of control and realism that UIKit Dynamics gives your views can be used to go beyond what come from the UIView animations API.  Let's change up how a view is presented in an image viewing app.  


# DEMO

I've got an app here that displays some images, and presents an enlarged view when you tap on it, along with some metadata.  

[Run the app here]

I want to modify the behavior when the enlarged view appears - currently it's driven by a UIVIew animation, but I want to change it to someting driven by UIKit Dynamic Behaviors.  

First, I'll add a UIDynamicAnimator property to the top of the class.

```
//1. Add a UIDynamicAnimator
var animator: UIDynamicAnimator!
```

Then in viewDidLoad, I'll initialize that property, providing the view of the viewcontroller as the reference view in the initializer. 

```
//2. Initialize the UIDynamicAnimator
animator = UIDynamicAnimator(referenceView: self.view)
```
Next, I'm going to remove the existing code in `showFullImageView` and replace it with some behaviors code.  First, I want to update the navigation bar after the UIKit Dynamic Animations have ended, so I'll fire off some actions to take place after a short delay.

```
func showFullImageView(_ index: Int) {
//3
let delayTime = DispatchTime.now() + Double(Int64(0.75 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
DispatchQueue.main.asyncAfter(deadline: delayTime) {
  let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PhotosCollectionViewController.dismissFullPhoto(_:)))
  self.navigationItem.rightBarButtonItem = doneButton
}
```
This code uses DispatchQueue.main.asyncAfter to set the right bar button of the navigation bar to the `doneButton` defined in the block, which calls `dismissFullPhoto`

Next, grab the image, and center of above the thumbnails, just off screen
```
//4
fullPhotoViewController.photoPair = photoData[index]
fullPhotoView.center = CGPoint(x: fullPhotoView.center.x, y: fullPhotoView.frame.height / -2)
fullPhotoView.isHidden = false
```
Not only does this code set the view to be off screen, it also sets it to not be hidden.  


Then, I'll remove all the current behaviors (if any exist), and then setup a UIDynamicItemBehavior, passing in the fullPhotoView as the item to which I want to apply this behavior.  To make it a little lively, I'll give it an elasticity of 0.2 and a density of 400.
```
//5
animator.removeAllBehaviors()

let dynamicItemBehavior = UIDynamicItemBehavior(items: [fullPhotoView])
dynamicItemBehavior.elasticity = 0.2
dynamicItemBehavior.density = 400
animator.addBehavior(dynamicItemBehavior)
```
Once defined, I'll add that behavior to the animator with addBehavior.  

Then I want to add a gravity behavior - again to the fullPhotoView - that will pull the view towards the bottom of the screen at a rapid rate.  To do that I'll set the magnitude to 5.0

```
let gravityBehavior = UIGravityBehavior(items: [fullPhotoView])
gravityBehavior.magnitude = 5.0
animator.addBehavior(gravityBehavior)
```
As before, I'll add that behavior to the animator.  

FInally, I'll setup a collision behavior - again on the fullPhotoView.  I'll define a left and right point, which will in turn define a line that exists just off the screen.  Add that boundary to the collisionBehavior, and then add that behavior to the animator.

```
let collisionBehavior = UICollisionBehavior(items: [fullPhotoView])
let left = CGPoint(x: 0, y: fullPhotoView.frame.height + 1.5)
let right = CGPoint(x: fullPhotoView.frame.width, y: fullPhotoView.frame.height + 1.5)
collisionBehavior.addBoundary(withIdentifier: "bottom" as NSCopying, from: left, to: right)
animator.addBehavior(collisionBehavior)
}
```

Setting the collision line just outside the bottom of the screen will cause the view to bounce, but NOT leave a visible gap when it does so - it's a little more aesthetically pleasing. Let's look at that in the simulator

If this isn't the look for you, you can tweak the parameters here to get just the right bounce you want!

# Outro

The animations API in UIView lets you bring your views to life, but UIKit Dynamics behaviors bring it up a notch, giving you a finer level of control on the behaviors of the view, bringing more realism into your app.  

That's a quick look at how you can use behaviors in UIKit Dynamics to replace UIView animations.    

Continue to come back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!
