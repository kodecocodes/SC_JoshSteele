# UIKit Dynamics - Basics


# Screencast Metadata

## Screencast Title

UIKit Dynamics - Basics

## Screencast Description

In iOS 9, UIKit Dynamics gained some new behaviors, including gravity fields, non-rectangular collision bounds and additional attachment behaviors.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0
* **Editor**: Xcode 10.0


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  In this screencast, I'll go over some of the basics of UIKit Dynamics, including some of the new behaviors that were introduced in iOS 9. 

Before we get started, I'd like to give a big thanks to Aaron Douglas, who wrote the UIKit Dynamics chapter in iOS 9 by Tutorials,  which is the basis for this screen cast.

UIKit Dynamics is a 2D physics inspired animation system with a high level API, allowing you to simulate physics experiences in your animations and view interactions.  iOS 9 included new behaviors such as gravity fields, non-rectangular collision bounds and additional attachment behaviors.  

Before we get into some code, let's go over a few terms: Dynamic Behaviors encapsulate the physics for a particular effect like gravity, attraction or bounce.  Dynamic animators keep track of where all of your items are during the animation process.  Animators take in a reference view, and all of the subviews you animate must be subviews of the reference view.  

Swift playgrounds are a great place to play around with UIKit Dynamics, and it's really easy to get some basic behaviors set up.  Let's take a look.


# DEMO

I've got a playground already setup, and I've got some code in place to draw 2 views - one white, another orange, on a light grey view background.  Right now they don't do much, but we can quickly add some dynamics to our views to make them a bit more lively.

First, let's add an animator.  Remember, UIDynamicAnimator needs a reference view, which contains the subviews we'll want to animate.  In this case it's the parent view:

```
let animator = UIDynamicAnimator(referenceView: view)
```

Next, we can quickly add a gravity behavior to the orange square using UIGravityBehavior, and add that behavior to the animator with the `addBehavior` method

```
animator.addBehavior(UIGravityBehavior(items: [orangeSquare]))
```

If we run the playground now, the orange view will feel the pull of gravity, but it falls off the edge!  We can fix this by using a UICollisionBehavior.  

```
let boundaryCollision = UICollisionBehavior(items: [whiteSquare, orangeSquare])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)
```

This code initializes the UICollisionBehavior object with both the white and orange views.  The `translatesReferenceBoundsIntoBoundary` code makes the border of the reference view into another boundary.  

If we run this again, the orange view stops, but it could be a little more life like - let's add some bounce to it with a UIDynamicItemBehavior.  This class allows you to tweak how behaviors respond to collisions and other physical traits.  

```
let bounce = UIDynamicItemBehavior(items: [orangeSquare])
bounce.elasticity = 0.6
bounce.density = 200
bounce.resistance = 2
animator.addBehavior(bounce)
```

Here, we're modifying the behavior of the orange square - and in particular, the elasticity, the density, and the linear resistance (which reduces linear velocity over time), and then adds that bounce behavior to the animator.  If we run the playground again, the bounce is litlte more lively at the bottom - play with the values to get the response you want!

Finally, we can turn on a little visual debugging help :

`animator.setValue(true, forKey: "debugEnabled")`

Enabling this key turns on some visual debug in the animator - note that if you run it now, you'll see a blue border around the orange view when it's animating.  This border shows the collision boundary.  Depending on what behaviors you're playing with, this visual debugging information can come in quite handy!


# Outro

A key way to keep your user engaged is to make your app interesting to look at and interact with.  UIKit Dynamics give you an easy way to add physics based behaviors to the views in your app, and to customize those interactions to get them just right.  
 
 That's a quick look at the basics of UIKit Dynamics  Continue to come back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!
