//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/29/22.
//

import Foundation
import UIKit

final class BottomNavigationHandler {
  private(set) var controllerHash: [Int: UIViewController] = [:]
  private(set) var currentIndex: Int = 1
  
  public func addController(_ controller: UIViewController, atIndex index: Int) {
    if controllerHash[index] == nil {
      controllerHash[index] = controller
    }
  }
  
  public func removeController(atIndex index: Int) {
    guard let hashIndex = controllerHash.firstIndex(where: { $0.key == index }) else { return }
    controllerHash.remove(at: hashIndex)
  }
}
