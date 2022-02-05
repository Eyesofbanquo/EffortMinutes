//
//  MainViewController.swift
//  EffortMinutes
//
//  Created by Markim Shaw on 1/18/22.
//

import Foundation
import UIKit
import RealmSwift
import SnapKit
import EffortDesign
import EffortModel
import EffortPresentation

/* Components */
import EMRankLadder
import EMTimer
import EMAddCategory

final class MainViewControllerContainer: UIViewController {
  
  let categories: [EMCategory] = [EMCategory(id: 0, name: "Reading", effortMinutes: 100),
                                  EMCategory(id: 1, name: "Writing", effortMinutes: 6700),
                                  EMCategory(id: 2, name: "Eating", effortMinutes: 75000)]
  lazy var tabBar: BottomNavigationBar = BottomNavigationBar()
  lazy var store: Store = {
#if DEBUG
    let config: Realm.Configuration = .init(inMemoryIdentifier: "DEBUG")
    let realm = try! Realm(configuration: config)
    return DataMapper(realm: realm)
#else
    return DataMapper()
#endif
  }()
  lazy var categoryBar: RankDisplayBarView = RankDisplayBarView()
  
  var controllerHash: [Int: UIViewController] = [:]
  var currentIndex: Int = 1
  
  lazy var viewCategoriesTransitioningDelegate: GenericTransitioningDelegate =
  GenericTransitioningDelegate(presentation: PopPresentAnimation(),
                               dismissal: PopDismissAnimation(),
                               blurEffectStyle: .systemThinMaterialDark)
  
  let rankViewController: RankViewController = {
    let vc = RankViewController()
    let _ = vc.view
    return vc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* SHould launch something if there aren't any categories present */
    
    
    view.backgroundColor = .white
    
    tabBar.translatesAutoresizingMaskIntoConstraints = false
    tabBar.delegate = self
    
    tabBar.add(item: BottomNavigationBarItem(index: 0, icon: "house.circle.fill", label: "Home"))
    tabBar.add(item: BottomNavigationBarItem(index: 1, icon: "timer", label: ""))
    tabBar.add(item: BottomNavigationBarItem(index: 2, icon: "gearshape.fill", label: "Settings"))
    
    categoryBar.translatesAutoresizingMaskIntoConstraints = false
    categoryBar.delegate = self
    categoryBar.setCategory("Default Category")
    
    self.view.insertSubview(categoryBar, at: 90)
    self.view.addSubview(tabBar)
    tabBar.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self.view)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
    categoryBar.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self.view)
      make.bottom.equalTo(tabBar.snp.top)
      make.centerX.equalTo(self.view)
    }
    
    let timer = TimerViewController()
    self.add(rankViewController, atIndex: 0)
    self.add(timer, atIndex: 1)
    tabBar.setSelected(1, animated: false)
  }
  
  private func add(_ child: UIViewController, atIndex index: Int) {
    child.view.translatesAutoresizingMaskIntoConstraints = false
    
    self.addChild(child)
    self.view.insertSubview(child.view, belowSubview: categoryBar)
    child.view.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self.view)
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(self.categoryBar.snp.top)
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
    /* These need to be added off rip or else the delegate call below will crash or do nothing */
    switch index {
      case 0:
        if categories.count > 0 {
          rankViewController.setEMCategory(categories.first!)
        }
        vc = rankViewController
      case 1:
        vc = TimerViewController()
      default: break
    }
    self.add(vc, atIndex: index)
    self.currentIndex = index
    print(index)
  }
}

extension MainViewControllerContainer: RankDisplayBarViewDelegate {
  func rankDisplayBarView(_ bar: RankDisplayBarView, didSelectView: Bool) {
    let builder = CategoryContainerBuilder.instance(usingStore: self.store) { [weak bar] category in
      bar?.setCategory(category.name)
    }
    builder.transitioningDelegate = viewCategoriesTransitioningDelegate
    builder.modalPresentationStyle = .custom
    self.present(builder, animated: true, completion: nil)
  }
}
