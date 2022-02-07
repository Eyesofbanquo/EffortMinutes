//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/31/22.
//

import Foundation
import UIKit
import EffortDesign
import EffortModel

public class CategoryContainerBuilder {
  
  public static func instance(object: CategoriesViewControllerDelegate.Type = CategoriesView.self,
                              usingStore store: Store,
                              onSelect: ((EMCategory) -> Void)? = nil) -> UINavigationController {
    let categoriesController = CategoriesViewController(object: object, store: store, onSelect: onSelect)
    let navigationController = UINavigationController(rootViewController: categoriesController)
    return navigationController
  }

}
