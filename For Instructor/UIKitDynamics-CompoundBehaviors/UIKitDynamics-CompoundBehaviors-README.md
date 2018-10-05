# UIKit Dynamics - Compound Behaviors


# Screencast Metadata

## Screencast Title

UIKit Dynamics - Compound Behaviors

## Screencast Description

Behaviors in UIKit Dynamics can be combined to make compound behaviors, making your behaviors more complex, but still using the high level UIKit Dynamics API.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0
* **Editor**: Xcode 10.0


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  In this screencast, I'll go over how behaviors in UIKit Dynamics can be combined into compound behaviors.  

Before we get started, I'd like to give a big thanks to Aaron Douglas, who wrote the UIKit Dynamics chapter in iOS 9 by Tutorials,  which is the basis for this screen cast.

UIKit Dynamics is a 2D physics inspired animation system with a high level API, allowing you to simulate physics experiences in your animations and view interactions.  iOS 9 included new behaviors such as gravity fields, non-rectangular collision bounds and additional attachment behaviors.  

Before we get into some code, let's go over a few terms: Dynamic Behaviors encapsulate the physics for a particular effect like gravity, attraction or bounce.  Dynamic animators keep track of where all of your items are during the animation process.  Animators take in a reference view, and all of the subviews you animate must be subviews of the reference view.  

Swift playgrounds are a great place to play around with UIKit Dynamics, and it's really easy to get some basic behaviors set up.  Let's take a look.


# DEMO

I've got a playground already setup, and I've got some code in place to draw 2 views - one white, another orange, on a light grey view background.  A gravity behavior, a collision behavior, and a UIDynamicItemBehavior have already been applied, which drops the orange view to the bottom of the screen, where it bounces when the collision takes place  

Let's add some additional behaviors to our animator, this time in a compound behavior

First, I'll make a parent behavior, to which I'll add a UIDynamicItemBehavior for the white square.

```
let parentBehavior = UIDynamicBehavior()
let viewBehavior = UIDynamicItemBehavior(items: [whiteSquare])
viewBehavior.density = 0.01
viewBehavior.resistance = 10
viewBehavior.friction = 0.0
viewBehavior.allowsRotation = false
parentBehavior.addChildBehavior(viewBehavior)
```

This tweaks the behavior attributes of the white square, including its mass density, linear resistance (which reduces linear velocity over time), friction (which is the linear resistance when two items slide against each other), as well as disabling the ability for that view to rotate.  

Next, let's define a field behavior, and in particular, a spring field.  Spring fields drag items caught inside its region into the center of the field. 

```
let fieldBehavior = UIFieldBehavior.springField()
fieldBehavior.addItem(whiteSquare)
fieldBehavior.position = CGPoint(x: 150, y: 350)
fieldBehavior.region = UIRegion(size: CGSize(width: 500, height: 500))
parentBehavior.addChildBehavior(fieldBehavior)
```
Here, I've added the field behavior to the white square and then defined the extent of the field - the position and the region.  Finally, I added the field behvaior to the parent behavior I established earlier.  

Now since the parent behavior is defined, I can add it to the animator with the `addBehavior` method.  

```
animator.addBehavior(parentBehavior)
```

If I run the playground now, the orange view falls as before, but the white view is now caught within the spring field, and settles into place in the center of the field.  To really see the effect of the spring field, let's use a push behavior to drive the view to the top of the parent view.

```
let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
DispatchQueue.main.asyncAfter(deadline: delayTime) {
  let pushBehavior = UIPushBehavior(items: [whiteSquare], mode: .instantaneous)
  pushBehavior.pushDirection = CGVector(dx: 0, dy: -1)
  pushBehavior.magnitude = 0.3
  animator.addBehavior(pushBehavior)
}
```

Here, I defined a slight time delay so I can wait for the view to settle before pushing it.  Then using `DispatchQueue.main.asyncAfter`, I define a UIPushBehavior on the white square, pushing it with a magnitude of 0.3 in the up direction.  

If I run the playground now, after settling into the spring field, the white view is pushed abruptly upwards, and then gets drawn back down into the spring field, once again, settling at the center.  

Finally, let's look at one more behavior - UIAttachmentBehavior.  I can attach a view - here the orange view to an anchor - with an attachment of a certain length.  

```
let attachment = UIAttachmentBehavior(item: orangeSquare, attachedToAnchor: CGPoint(x: 300, y: 100))
attachment.length = 300
animator.addBehavior(attachment)
```

If I run the playground now, the orange view is now attached to an anchor that is just above the right corner of the spring field, and due to the attachment length, actually starts the orange view at a different location than before.  The gravity behavior field still works on the orange view though, so it swings down like a pendulum and settles eventually.  Note that the orange view is NOT impacted by the spring field, since we only assigned that behavior to the white view.  

# Outro

A key way to keep your user engaged is to make your app interesting to look at and interact with.  UIKit Dynamics give you an easy way to add physics based interactions to the views in your app, and to customize those interactions to get them just right.   Behaviors can also be easily combined into compound behaviors to generate a single behavior object that contains all the behavior for a set of objects.  

That's a quick look at some other behaviors in UIKit Dynamics, and how you can make compound behaviors in UIKit Dynamics.  Continue to come back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!
