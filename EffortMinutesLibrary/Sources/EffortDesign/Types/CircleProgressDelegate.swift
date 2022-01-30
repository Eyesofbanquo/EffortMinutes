//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import UIKit

public protocol CircleProgressDelegate: AnyObject {
  func circleProgress(_ circleProgress: CircleProgress,
                      degress: Double)
}
