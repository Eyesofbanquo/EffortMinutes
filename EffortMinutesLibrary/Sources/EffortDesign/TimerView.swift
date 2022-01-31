//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import UIKit
import SnapKit

public protocol TimerViewDelegate: AnyObject {
  func timerView(_ timerView: TimerView, didUpdateTime time: TimeInterval)
}

public final class TimerView: UIView {
  
  public enum State {
    case active, inactive
  }
  
  static private var IntentionalMinutes: [TimeInterval] = [
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
  
  var currentPosition: Int
  
  public var selectedTime: TimeInterval {
    return Self.IntentionalMinutes[currentPosition]
  }
  
  var disabled: Bool = false
  
  public weak var delegate: TimerViewDelegate?
  
  public var state: State = .inactive
  
  public init() {
    self.timeLabel = UILabel()
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.text = "\(Self.IntentionalMinutes[0]):00 IM"
    timeLabel.textColor = .init(hexString: "#263D42")
    timeLabel.font = .preferredFont(forTextStyle: .title1)
    
    currentPosition = 0
    
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
  
  public func start() {
    /* Hide */
    circleProgress.deactivate()
    
    self.state = .active
  }
  
  public func stop() {
    /* */
    circleProgress.activate()
    self.state = .inactive
  }
  
  public func setTimerText(_ text: String?) {
    UIView.transition(with: timeLabel, duration: 0.4, options: .curveEaseInOut) {
      self.timeLabel.text = text
    }
  }
}

extension TimerView: CircleProgressDelegate {
  
  public func circleProgress(_ circleProgress: CircleProgress, degress: Double) {
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
    print(Self.IntentionalMinutes[currentPosition], currentPosition)
    delegate?.timerView(self, didUpdateTime: Self.IntentionalMinutes[currentPosition])
//    timeLabel.text = "\(Self.IntentionalMinutes[currentPosition]):00 IM"
    
  }
}
