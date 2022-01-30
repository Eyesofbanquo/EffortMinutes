//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/28/22.
//

import Foundation

public struct EMCategory {
  public let name: String
  public let effortMinutes: Int
  
  public init(name: String, effortMinutes: Int) {
    self.name = name
    self.effortMinutes = effortMinutes
  }
}
