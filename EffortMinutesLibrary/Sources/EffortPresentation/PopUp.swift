//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import UIKit
import SnapKit

final public class GenericTransitioningDelegate<Presentation: UIViewControllerAnimatedTransitioning, Dismissal: UIViewControllerAnimatedTransitioning>: NSObject, UIViewControllerTransitioningDelegate {
  
  var presentation: Presentation
  var dismissal: Dismissal
  
  public init(presentation: Presentation, dismissal: Dismissal) {
    self.presentation = presentation
    self.dismissal = dismissal
  }
  
  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return DimmedPresentationController(presentedViewController: presented, presenting: presenting)
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PopDismissAnimation()
  }
  
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PopPresentAnimation()
  }
  
}

final public class PopPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.4
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let key: UITransitionContextViewControllerKey = .to
    
    /* Get the controller we plan to present */
    guard let controller = transitionContext.viewController(forKey: key)
    else { return }
    
    /* Add to container */
    transitionContext.containerView.addSubview(controller.view)
    
    controller.view.snp.makeConstraints { make in
      make.centerX.equalTo(transitionContext.containerView)
      make.centerY.equalTo(transitionContext.containerView)
      make.height.equalTo(transitionContext.containerView.snp.height).dividedBy(2)
      make.width.equalTo(transitionContext.containerView.snp.height).dividedBy(2)
    }
    
    /* Shrink view */
    controller.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    controller.view.alpha = 0.0
    
    let animationDuration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 0.0, options: .curveEaseOut) {
      controller.view.alpha = 1.0
      controller.view.transform = .identity
      controller.view.clipsToBounds = true
      controller.view.layer.cornerRadius = 16.0
    } completion: { finished in
      transitionContext.completeTransition(finished)
    }
  }
  
  
}


final public class PopDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.4
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let key: UITransitionContextViewControllerKey = .from
    
    /* Get the controller we plan to present */
    guard let controller = transitionContext.viewController(forKey: key)
    else { return }
    
    let animationDuration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.67, initialSpringVelocity: 2.0, options: .curveEaseOut) {
      controller.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
      controller.view.alpha = 0.0
    } completion: { finished in
      controller.view.removeFromSuperview()
      transitionContext.completeTransition(finished)
    }
  }
  
  
}
