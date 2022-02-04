//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import UIKit
import SnapKit

final public class DimmedPresentationController: UIPresentationController {
  
  lazy var dimmingView: UIView = setupDimmingView()
  
  var blurEffectStyle: UIBlurEffect.Style = .systemUltraThinMaterialLight
  
  var presentedViewFrame: CGRect = .zero
  
  lazy var blurEffectView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: blurEffectStyle)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    blurView.alpha = 0.0
    return blurView
  }()
  
  lazy var vibrancyEffectView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
    let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
    vibrancyView.translatesAutoresizingMaskIntoConstraints = false
    vibrancyView.alpha = 0.0
    return vibrancyView
  }()
  
  override public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
  }
  
  public convenience init(presentedViewController: UIViewController,
                          presenting presentingViewController: UIViewController?,
                          blurEffectStyle: UIBlurEffect.Style) {
    self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    self.blurEffectStyle = blurEffectStyle
    
    /* Add dismiss on tap */
    let recognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(self.handleDismissTap(_:)))
    blurEffectView.addGestureRecognizer(recognizer)
    
    /* For handling keyboard events */
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if self.presentedView?.frame.origin.y == presentedViewFrame.origin.y {
        self.presentedView?.frame.origin.y = (self.presentedView!.frame.origin.y + self.presentedView!.frame.height / 2) - (keyboardSize.height + 8.0)
        self.presentedView?.setNeedsLayout()
        self.presentedView?.layoutIfNeeded()
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.presentedView?.frame.origin.y != presentedViewFrame.origin.y {
        self.presentedView?.frame.origin.y = (self.presentedView!.frame.origin.y - self.presentedView!.frame.height / 2) + (keyboardSize.height + 8.0)
        self.presentedView?.setNeedsLayout()
        self.presentedView?.layoutIfNeeded()
      }
    }
  }
  
  override public func presentationTransitionWillBegin() {
    guard let containerView = containerView else { return }
    containerView.insertSubview(blurEffectView, at: 0)
    
    blurEffectView.snp.makeConstraints { make in
      make
        .leading
        .trailing
        .top
        .bottom.equalTo(containerView)
    }
    
    guard let coordinator = presentedViewController.transitionCoordinator else {
      blurEffectView.alpha = 1.0
      return
    }
    
    coordinator.animate { _ in
      self.blurEffectView.alpha = 1.0
    }
  }
  
  override public func presentationTransitionDidEnd(_ completed: Bool) {
    self.presentedViewFrame = presentedView?.frame ?? .zero
  }
  
  override public func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      blurEffectView.alpha = 0.0
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.blurEffectView.alpha = 0.0
    })
  }
}

extension DimmedPresentationController {
  private func setupDimmingView() -> UIView {
    let dimmingView = UIView()
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    dimmingView.alpha = 0.0
    return dimmingView
  }
  
  @objc private func handleDismissTap(_ recognizer: UITapGestureRecognizer) {
    presentingViewController.dismiss(animated: true, completion: nil)
  }
}
