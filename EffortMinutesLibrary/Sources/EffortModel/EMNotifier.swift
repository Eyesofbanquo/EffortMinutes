//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/1/22.
//

import Foundation
import Combine
import Realm
import RealmSwift

public protocol EMNotifierDelegate: AnyObject {
  func emNotifier<T: Object>(_ notifier: EMNotifier<T>, didReceiveInitialResults results: [T])
  func emNotifier<T: Object>(_ notifier: EMNotifier<T>, didReceiveUpdate results: [T], deletions: [Int], insertions: [Int], modifications: [Int])
  func emNotifier<T: Object>(_ notifier: EMNotifier<T>, didReceiveError error: EMNotifier<T>.EMNotifierError)
}

/// An object that encapsulates a realm notification token. Requires a `Realm` object.
public class EMNotifier<T: Object> {
  
  public enum EMNotifierError: Error {
    case genericError
  }
  
  var notificationToken: NotificationToken?
  public weak var delegate: EMNotifierDelegate?
  
  public init(realm: Realm) {
    let collection = realm.objects(T.self)
    notificationToken = collection.observe { changes in
      switch changes {
        case .initial(let results):
          self.delegate?.emNotifier(self, didReceiveInitialResults: Array(results))
        case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
          self.delegate?.emNotifier(self, didReceiveUpdate: Array(results), deletions: deletions, insertions: insertions, modifications: modifications)
        case .error:
          self.delegate?.emNotifier(self, didReceiveError: .genericError)
      }
    }
  }
  
  deinit {
    scheduleDeinit()
  }
  
  public func scheduleDeinit() {
    notificationToken?.invalidate()
    notificationToken = nil
  }
}
