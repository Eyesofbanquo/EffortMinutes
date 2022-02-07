//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/5/22.
//

import Foundation
import UIKit
import EffortModel

public protocol OnboardingViewControllerDelegate: AnyObject {
  /* Properties */
  
  /// This represents the potential view to project
  var projectedView: UIView? { get }
  var viewDelegate: OnboardingViewDelegate? { get set }
  
  /* init */
  init()
  
  /* Actions */
  func onboardingViewControllerDelegate(_ delegate: OnboardingViewDelegate, didReceiveCategory category: EMCategory) 
}
