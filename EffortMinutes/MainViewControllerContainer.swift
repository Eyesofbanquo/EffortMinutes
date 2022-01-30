//
//  MainViewController.swift
//  EffortMinutes
//
//  Created by Markim Shaw on 1/18/22.
//

import Foundation
import UIKit
import SnapKit
import EffortDesign
import EffortModel
import EMRankLadder

final class MainViewControllerContainer: UIViewController {
  
  let categories: [EMCategory] = [EMCategory(name: "Reading", effortMinutes: 100),
                                  EMCategory(name: "Writing", effortMinutes: 6700),
                                  EMCategory(name: "Eating", effortMinutes: 75000)]
  lazy var tabBar: BottomNavigationBar = BottomNavigationBar()
  lazy var rankPickerView: RankPickerView = RankPickerView(categories: categories)
  
  var controllerHash: [Int: UIViewController] = [:]
  var currentIndex: Int = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    tabBar.translatesAutoresizingMaskIntoConstraints = false
    tabBar.delegate = self
    
    tabBar.add(item: BottomNavigationBarItem(index: 0, icon: "house.circle.fill", label: "Home"))
    tabBar.add(item: BottomNavigationBarItem(index: 1, icon: "timer", label: ""))
    tabBar.add(item: BottomNavigationBarItem(index: 2, icon: "gearshape.fill", label: "Settings"))
    
    rankPickerView.translatesAutoresizingMaskIntoConstraints = false
    rankPickerView.delegate = self
    
    self.view.insertSubview(rankPickerView, at: 90)
    self.view.addSubview(tabBar)
    tabBar.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self.view)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
    rankPickerView.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self.view)
      make.bottom.equalTo(tabBar.snp.top)
      make.centerX.equalTo(self.view)
    }
    
    let timer = ViewController()
    self.add(timer, atIndex: 1)
  }
  
  private func add(_ child: UIViewController, atIndex index: Int) {
    self.addChild(child)
//    self.view.addSubview(child.view)
    self.view.insertSubview(child.view, belowSubview: rankPickerView)
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

extension MainViewControllerContainer: BottomNavigationBarItemDelegate {
  
  func mainTabBarItem(_ item: BottomNavigationBarItem, didSelectIndex index: Int) {
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
    /* THese need to be added off rip or else the delegate call below will crash or do nothing */
    switch index {
      case 0:
        vc = RankViewController()
        let _ = vc.view
        if categories.count > 0 {
          (vc as? RankViewController)?.setEMCategory(categories.first!)
        }
      case 1:
        vc = ViewController()
      default: break
    }
    self.add(vc, atIndex: index)
    self.currentIndex = index
    print(index)
  }
}

extension MainViewControllerContainer: RankPickerViewDelegate {
  func rankPickerView(_ rankPickerView: RankPickerView, didSelectCategory category: EMCategory) {
    /* CHange */
    let rankViewControllerHash = controllerHash.first(where: { ($0.value as? RankViewController ) != nil })
    guard let rankVC = rankViewControllerHash?.value as? RankViewController else {
      return
    }
    rankVC.setEMCategory(category)
  }
  
  
}
