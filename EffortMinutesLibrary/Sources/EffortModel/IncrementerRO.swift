//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/30/22.
//

import Foundation
import RealmSwift

public class IncrementerRO: Object {
  @Persisted public var currentIncrement: Int = 0
}
