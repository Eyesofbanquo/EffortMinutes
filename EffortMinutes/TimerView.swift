//
//  TimerView.swift
//  EffortMinutes
//
//  Created by Markim Shaw on 1/18/22.
//

import Foundation
import UIKit
import SnapKit

protocol TimerViewDelegate: AnyObject { }

final class TimerView: UIView {
  
  static private var IntentionalMinutes: [Int] = [
    10, 15, 20,
    25, 30, 35,
    35, 40, 45,
    50,
    55, 60
  ]
  
  static private var circleRadians = 360.0
  
  static private var division = circleRadians / Double(IntentionalMinutes.count)
  
  static private var divisions: [Double] = {
    var divisions: [Double] = []
    for i in (0...IntentionalMinutes.count-1) {
      let value = Double(i) * division
      switch value {
        case 0...90:
          let value = 90.0 - value
          divisions.append(value)
          break
        case 91...179:
          let complement = value - 90.0
          let value = 360.0 - complement
          divisions.append(value)
        case 180...269:
          let complement = value - 180.0
          let value = 270.0 - complement
          divisions.append(value)
        case 270...359:
          let complement = value - 270.0
          let value = 180.0 - complement
          divisions.append(value)
        default: print("no quad")
      }
    }
    return divisions
  }()
  
  
  lazy private var circleProgress: CircleProgress = {
    let circleView = CircleProgress(args: (radius: 100.0, outlineColor: .init(hexString: "#263D42"), lineWidth: 6.0, ballRadius: 20.0, ballColor: .init(hexString: "#80CED7"), maxValue: 60))
    circleView.translatesAutoresizingMaskIntoConstraints = false
    return circleView
  }()
  
  private var timeLabel: UILabel
  
  var currentPosition: Int?
  
  var disabled: Bool = false
  
  weak var delegate: TimerViewDelegate?
  
  init() {
    self.timeLabel = UILabel()
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.text = "\(Self.IntentionalMinutes[0]):00 IM"
    timeLabel.textColor = .init(hexString: "#263D42")
    timeLabel.font = .preferredFont(forTextStyle: .title1)
    
    super.init(frame: .zero)
    
    addSubview(circleProgress)
    circleProgress.snp.makeConstraints { make in
      make.leading.bottom.top.trailing.equalTo(self)
    }
    circleProgress.delegate = self
    
    addSubview(timeLabel)
    timeLabel.snp.makeConstraints { make in
      make.center.equalTo(self)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

extension TimerView: CircleProgressDelegate {
  func circleProgress(_ circleProgress: CircleProgress, degress: Double) {
    for i in (0..<Self.IntentionalMinutes.count) {
      guard i + 1 < Self.IntentionalMinutes.count else {
        currentPosition = Self.IntentionalMinutes.count - 1
        continue
      }
      
      if degress < 360.0 && degress > 360.0 - Self.division {
        currentPosition = 3
        break
      }
      
      if degress < Double(Self.divisions[i]) && degress > Double(Self.divisions[i+1]) {
        currentPosition = i
        break
      }
    }
    
    
    if let currentPosition = currentPosition {
      print(Self.IntentionalMinutes[currentPosition], currentPosition)
      timeLabel.text = "\(Self.IntentionalMinutes[currentPosition]):00 IM"
    }
    
  }
}
