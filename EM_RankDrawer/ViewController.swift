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

class ViewController: UIViewController {
  
  lazy var rankDrawer = RankPickerView(categories: [EMCategory(name: "Reading", effortMinutes: 100),
                                                    EMCategory(name: "Writing", effortMinutes: 100),
                                                    EMCategory(name: "Eating", effortMinutes: 100)])

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
