//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/28/22.
//

import Foundation
import EffortModel

public protocol RankPickerViewDelegate: AnyObject {
  func rankPickerView(_ rankPickerView: RankPickerView, didSelectCategory category: EMCategory)
}
