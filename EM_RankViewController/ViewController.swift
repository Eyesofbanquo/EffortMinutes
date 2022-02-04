//
//  ViewController.swift
//  EM_RankViewController
//
//  Created by Markim Shaw on 1/27/22.
//

import UIKit
import EMRankLadder
import SnapKit
import EffortModel

class ViewController: UIViewController {
  
  lazy var vc = RankViewController()

  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(vc)
    view.addSubview(vc.view)
    vc.view.snp.makeConstraints { make in
      make
        .leading
        .trailing
        .bottom
        .top
        .equalTo(view)
    }
    vc.didMove(toParent: self)
    
    vc.setEMCategory(EMCategory(id: 0, name: "Reading", effortMinutes: 75000))
  }
  
  deinit {
    vc.willMove(toParent: nil)
    vc.view.removeFromSuperview()
    vc.removeFromParent()
  }


}

