//
//  MainViewController.swift
//  EffortMinutes
//
//  Created by Markim Shaw on 1/18/22.
//

import Foundation
import UIKit
import SnapKit

final class MainViewControllerContainer: UIViewController {
  
  lazy var tabBar: MainTabBar = MainTabBar()
  
  var controllerHash: [Int: UIViewController] = [:]
  var currentIndex: Int = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    tabBar.translatesAutoresizingMaskIntoConstraints = false
    tabBar.delegate = self
    
    tabBar.add(item: MainTabBarItem(index: 0, icon: "house.circle.fill", label: "Home"))
    tabBar.add(item: MainTabBarItem(index: 1, icon: "timer", label: ""))
    tabBar.add(item: MainTabBarItem(index: 2, icon: "gearshape.fill", label: "Settings"))
    
    self.view.addSubview(tabBar)
    tabBar.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self.view)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
    
    let timer = ViewController()
    self.add(timer, atIndex: 1)
  }
  
  private func add(_ child: UIViewController, atIndex index: Int) {
    self.addChild(child)
    self.view.addSubview(child.view)
    child.view.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self.view)
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(self.tabBar.snp.top)
    }
    child.didMove(toParent: self)
    
    if controllerHash[index] == nil {
      controllerHash[index] = child
    }
  }
  
  private func remove(_ child: UIViewController) {
    child.willMove(toParent: nil)
    child.view.removeFromSuperview()
    child.removeFromParent()
  }
}

extension MainViewControllerContainer: MainTabBarItemDelegate {
  
  func mainTabBarItem(_ item: MainTabBarItem, didSelectIndex index: Int) {
    guard index != currentIndex else { return }
    
    for controller in Array(controllerHash.values) {
      self.remove(controller)
    }
    
    if let hashedVC = controllerHash[index] {
      self.add(hashedVC, atIndex: index)
      self.currentIndex = index
      return
    }
    
    var vc: UIViewController!
    
    switch index {
      case 0:
        vc = RankViewController()
      case 1:
        vc = ViewController()
      default: break
    }
    
    self.add(vc, atIndex: index)
    self.currentIndex = index
    print(index)
  }
}
