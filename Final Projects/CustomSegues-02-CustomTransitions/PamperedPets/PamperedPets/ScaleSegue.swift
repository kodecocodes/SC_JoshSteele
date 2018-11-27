//
//  ScaleSegue.swift
//  PamperedPets
//
//  Created by Teacher on 11/26/18.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import UIKit

protocol ViewScaleable {
  var scaleView:UIView { get }
}

class ScaleSegue: UIStoryboardSegue {

  override func perform() {
    destination.transitioningDelegate = self
    super.perform()
  }
}

extension ScaleSegue: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScalePresentAnimator()
  }

}

class ScalePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 2.0
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    var fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
    
    // 1. Get the transition context to- controller and view
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
    
    // 2. Add the to- view to the transition context
    if let toView = toView {
      transitionContext.containerView.addSubview(toView)
    }
    
    // 3. Set up the initial state for the animation
    var startFrame = CGRect.zero
    if let fromViewController = fromViewController as? ViewScaleable {
      startFrame = fromViewController.scaleView.frame
    } else {
      print("Warning: Controller \(fromViewController) does not conform to ViewScaleable")
    }
    toView?.frame = startFrame
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
}
