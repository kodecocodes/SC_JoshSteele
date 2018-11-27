/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

// MARK:- Custom Segue

class DropSegue: UIStoryboardSegue {

  override func perform() {
    destination.transitioningDelegate = self
    super.perform()
  }
}

extension DropSegue: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController,
     presenting: UIViewController,
     source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DropPresentAnimator()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DropDismissAnimator()
  }
}

// MARK:- Animator

class DropPresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // 1. Get the transition context to- view controller and view
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)

    // 2. Add the to-view to the transition context
    if let toView = toView {
      transitionContext.containerView.addSubview(toView)
    }

    // 3. Set up the initial state for the animation
    let finalFrame = transitionContext.finalFrame(for: toViewController)
    var startFrame = finalFrame
    startFrame.origin.y = -finalFrame.height
    
    toView?.frame = startFrame
    toView?.layoutIfNeeded()

    // 4. Perform the animation
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5,
      initialSpringVelocity: 6, options: UIView.AnimationOptions(), animations: {
      if let toView = toView {
        toView.frame = finalFrame
      }
      }, completion: {
        finished in
        // 5. Clean up the transition context
        transitionContext.completeTransition(true)
    })
  }
}

class DropDismissAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // 1. Get the transition context from- view controller and view
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
    
    // 2. Add the to-view to the transition context
    if let fromView = fromView {
      if let toView = toView {
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
      }
    }
    
    // 3. Set up the initial state for the animation
    var finalFrame = transitionContext.finalFrame(for: fromViewController)
    finalFrame.origin.y = -finalFrame.height
    
    // 4. Perform the animation
    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, animations: {
      if let fromView = fromView {
        fromView.frame = finalFrame
        fromView.layoutIfNeeded()
      }
      }, completion: {
        finished in
        // 5. Clean up the transition context
        transitionContext.completeTransition(true)
    })
  }
}

