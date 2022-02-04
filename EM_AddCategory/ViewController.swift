//
//  ViewController.swift
//  EM_AddCategory
//
//  Created by Markim Shaw on 1/31/22.
//

import UIKit
import EMAddCategory
import SnapKit
import EffortModel
import RealmSwift
import EffortPresentation

class ViewController: UIViewController {
  
  lazy var detailTransitioningDelegate: GenericTransitioningDelegate =
  GenericTransitioningDelegate(presentation: PopPresentAnimation(),
                               dismissal: PopDismissAnimation(),
                               blurEffectStyle: .systemThinMaterialDark)
  
  lazy var store: Store = {
    let config = Realm.Configuration(inMemoryIdentifier: "DEBUG")
    let realm = try! Realm(configuration: config)
    let cat = EMCategory(id: 0, name: "Markim", effortMinutes: 200)
    let cat2 = EMCategory(id: 1, name: "❤️", effortMinutes: 200)
    let cat3 = EMCategory(id: 2, name: "Kyrinne", effortMinutes: 200)
    try! realm.write {
      realm.add(EMCategoryRO(fromCategory: cat, atIndex: 0))
      realm.add(EMCategoryRO(fromCategory: cat2, atIndex: 1))
      realm.add(EMCategoryRO(fromCategory: cat3, atIndex: 2))
    }
    return DataMapper(realm: realm)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    var configuration = UIButton.Configuration.plain()
    let launchButton = UIButton(type: .system)
    configuration.title = "Press to launch controller"
    launchButton.configuration = configuration
    launchButton.addAction(UIAction(handler: { _ in
      let builder = CategoryContainerBuilder.instance(usingStore: self.store)
      builder.transitioningDelegate = self.detailTransitioningDelegate
      builder.modalPresentationStyle = .custom
      self.present(builder, animated: true, completion: nil)
    }), for: .touchUpInside)
    
    self.view.addSubview(launchButton)
    launchButton.snp.makeConstraints { make in
      make.center.equalTo(self.view)
    }
  }


}

