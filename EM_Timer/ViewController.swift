//
//  ViewController.swift
//  EM_Timer
//
//  Created by Markim Shaw on 1/30/22.
//

import UIKit
import SnapKit
import EffortDesign
import UserNotifications

class ViewController: UIViewController {
  
  var beginButton: UIButton!
  var timerLabel: UILabel = UILabel()
  
  var timer: Timer?
  var timerView = TimerView()
  var totalAccumulatedTime: Double = 0.0
  var maxTime: TimeInterval = 0.0
  var lastDateObserved: Date?
  
  let center = UNUserNotificationCenter.current()
  
  let formatter = DateComponentsFormatter()
  
  var timeRemaining: TimeInterval {
    (timerView.selectedTime * 60) - totalAccumulatedTime
  }
  var timerViewText: String {
    "\(timeRemaining / 60) IM"
  }
  
  static var TIMER_NOTIFICATION_IDENTIFIER: String = "timer"

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = .white
    
    timerLabel.translatesAutoresizingMaskIntoConstraints = false
    timerLabel.font = .preferredFont(forTextStyle: .caption1)
    
    var config = UIButton.Configuration.bordered()
    config.title = "Start"
    config.background.strokeColor = .init(hexString: "#263D42")
    config.background.strokeWidth = 1.5
    config.baseBackgroundColor = .clear
    config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    config.cornerStyle = .small
    config.baseForegroundColor = .init(hexString: "#263D42")
    
    beginButton = UIButton(type: .system)
    
    beginButton.configuration = config
    
    timerView.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(timerView)
    timerView.snp.makeConstraints { make in
      make.centerY.centerX.equalTo(self.view)
    }
    
    self.view.addSubview(beginButton)
    beginButton.snp.makeConstraints { make in
      make.centerX.equalTo(timerView)
    }
    
    self.view.addSubview(timerLabel)
    timerLabel.snp.makeConstraints { make in
      make.centerX.equalTo(beginButton)
      make.top.equalTo(timerView.snp.bottom).offset(16.0)
      make.bottom.equalTo(beginButton.snp.top).offset(-8.0)
    }
    
    /* Add timer start action */
    beginButton.addTarget(self, action: #selector(self.setReminder(_:forEvent:)), for: .touchUpInside)
    
    /* Set the default text for the timer */
    timerView.setTimerText(timerViewText)
    
    /* Add notification events for when app enters/leaves foreground/background */
    NotificationCenter.default.addObserver(forName: UIScene.didActivateNotification, object: nil, queue: nil) { _ in
      if self.timerView.state == .active {
        self.createTimer()
      }
    }
    
    NotificationCenter.default.addObserver(forName: UIScene.willDeactivateNotification, object: nil, queue: nil) { _  in
      print("Did go into background")
      if self.timerView.state == .active {
        self.removeTimer()
      }
    }
  }


  @objc func fireTimer() {
    guard let lastDateObserved = lastDateObserved else {
      return
    }

    let currentDate = Date().addingTimeInterval(-0.5)
    let currentAccumulatedTime = currentDate.timeIntervalSince(lastDateObserved)
    totalAccumulatedTime += currentAccumulatedTime
    
    /* Set the timer view text*/
    let timeRemainingString = formatter.string(from: timeRemaining) ?? ""
    let unitTimeRemainingString = timeRemainingString + " IM"
    timerView.setTimerText(unitTimeRemainingString)
    
    self.lastDateObserved = currentDate
    print("time accumulated", totalAccumulatedTime, "time remaining", timeRemaining)
  }
  
  @objc func setReminder(_ sender: UIButton, forEvent event: UIEvent) {
    /* Begin timer */
    if timer == nil {
      createTimer()
      timerView.start()
      createNotification()
      setMaxTime()
      timerLabel.text = formatter.string(from: maxTime)
      beginButton.configuration?.title = "Pause"
    } else {
      let timeRemainingString = formatter.string(from: timerView.selectedTime) ?? ""
      let unitTimeRemainingString = timeRemainingString + " IM"
      timerView.setTimerText(unitTimeRemainingString)
      timerLabel.text = ""
      removeTimer()
      resetTime()
    }
  }
  
  func createTimer() {
    guard timer == nil else { return }
    if lastDateObserved == nil {
      lastDateObserved = .now
    }
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    RunLoop.current.add(timer!, forMode: .common)
    timer?.tolerance = 0.1
  }
  
  func setMaxTime() {
    self.maxTime = Double(timerView.selectedTime * 60)
  }
  
  func removeTimer() {
    timer?.invalidate()
    timer = nil
    center.removeDeliveredNotifications(withIdentifiers: [Self.TIMER_NOTIFICATION_IDENTIFIER])
  }
  
  func resetTime() {
    totalAccumulatedTime = 0.0
    lastDateObserved = nil
    timerView.stop()
    self.maxTime = 0
    beginButton.configuration?.title = "Start"

  }
  
  func createNotification() {
    let content = UNMutableNotificationContent()
    
    content.title = "Effort Minutes"
    content.body = "You've just completed your session!"
    content.sound = .default
    content.userInfo = ["value": "Data with local notification"]
    
//    let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(TimeInterval(maxTime)))
    let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(2))
    let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
    let request = UNNotificationRequest(identifier: Self.TIMER_NOTIFICATION_IDENTIFIER, content: content, trigger: trigger)
    
    center.add(request) { (error) in
      if error != nil {
        print("Error = \(error?.localizedDescription ?? "error local notification")")
      }
    }
  }
  
  deinit {
    timer?.invalidate()
  }
}

extension ViewController: UNUserNotificationCenterDelegate {
  
}
