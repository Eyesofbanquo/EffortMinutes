//
//  ViewController.swift
//  EM_RankDrawer
//
//  Created by Markim Shaw on 1/28/22.
//

import UIKit
import EffortDesign
import EffortModel
import SnapKit
import RealmSwift

class ViewController: UIViewController {
  
  lazy var store: Store = {
    let config = Realm.Configuration(inMemoryIdentifier: "EM_RankDrawer")
    let mapper = DataMapper(realm: try! Realm(configuration: config))
    return mapper
  }()
  
  lazy var rankDrawer: RankPickerView = {
    /* Add items */
    let categories = [EMCategory(id: 0, name: "Reading", effortMinutes: 100),
                      EMCategory(id: 1, name: "Writing", effortMinutes: 100),
                      EMCategory(id: 2, name: "Eatingawfawfwa", effortMinutes: 100)]
    categories.forEach { category in
      try? self.store.addCategory(category)
    }
    
    let picker = RankPickerView(store: store)
    return picker
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    rankDrawer.delegate = self
    
    self.view.addSubview(rankDrawer)
    rankDrawer.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self.view)
      make.centerY.equalTo(self.view)
    }
    
  }
}

extension ViewController: RankPickerViewDelegate {
  func rankPickerView(_ rankPickerView: RankPickerView, didSelectCategory category: EMCategory) {
    print("Did select category \(category.name)")
  }
}
