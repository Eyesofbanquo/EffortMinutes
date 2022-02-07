//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/5/22.
//

import Foundation
import UIKit
import EffortDesign
import EffortModel

public class OnboardingViewController<T: OnboardingViewControllerDelegate>: UIViewController, OnboardingViewDelegate {
  
  // MARK: - Properties -
  var viewControllerDelegate: T
  
  /* Potential leak */
  lazy var keyboardHandler = KeyboardHandler(forView: &self.view, beginningPointY: 0.0)
  
  var store: Store
  
  // MARK: - init -
  public init(store: Store) {
    self.store = store
    self.viewControllerDelegate = T.init()
    
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle -
  
  public override func loadView() {
    guard let view = viewControllerDelegate.projectedView else {
      super.loadView()
      return
    }
    
    viewControllerDelegate.viewDelegate = self
    
    self.view = view
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    keyboardHandler.setup()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    (self.view as? OnboardingView)?.begin()
  }
}

extension OnboardingViewController {
  public func onboardingViewDelegateShouldDismiss(_ delegate: OnboardingViewControllerDelegate) {
    /* Log into UserDefaults that the onboarding has been finished */
    dismiss(animated: true, completion: nil)
  }
  
  public func onboardingViewDelegate(_ delegate: OnboardingViewControllerDelegate, didAddCategoryWithName name: String?) {
    guard let name = name, name.isEmpty == false else {
      /* present error alert */
      let alert = UIAlertController(title: "Invalid Category Name", message: "Please create a category with a valid name", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    /* Create a new category object */
    let category = EMCategory.init(id: 0, name: name, effortMinutes: 0)
    
    /* Add category to database */
    try? store.addCategory(category)
    
    /* Send category back to delegate */
    viewControllerDelegate.onboardingViewControllerDelegate(self, didReceiveCategory: category)
  }
}
