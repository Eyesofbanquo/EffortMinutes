//
//  ViewController.swift
//  CircleBuns
//
//  Created by Markim Shaw on 1/10/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  
  var ballView: UIView!
  var circleView: UIView!
  var beginButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    var config = UIButton.Configuration.bordered()
    config.title = "Begin"
    config.background.strokeColor = .init(hexString: "#263D42")
    config.background.strokeWidth = 1.5
    config.baseBackgroundColor = .clear
    config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    config.cornerStyle = .small
    config.baseForegroundColor = .init(hexString: "#263D42")

    beginButton = UIButton(type: .system)
    
    beginButton.configuration = config
    
    let timerView = TimerView()
    timerView.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(timerView)
    timerView.snp.makeConstraints { make in
      make.centerY.centerX.equalTo(self.view)
    }
    
    self.view.addSubview(beginButton)
    beginButton.snp.makeConstraints { make in
      make.centerX.equalTo(timerView)
      make.top.equalTo(timerView.snp.bottom).offset(16.0)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
   
  }
}

