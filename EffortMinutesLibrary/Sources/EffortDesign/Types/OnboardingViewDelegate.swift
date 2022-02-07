//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/5/22.
//

import Foundation

public protocol OnboardingViewDelegate: AnyObject {
  func onboardingViewDelegateShouldDismiss(_ delegate: OnboardingViewControllerDelegate)
  /// Pass through the name string to create a brand new `EMCategoryRO` type.
  func onboardingViewDelegate(_ delegate: OnboardingViewControllerDelegate, didAddCategoryWithName name: String?)
}
