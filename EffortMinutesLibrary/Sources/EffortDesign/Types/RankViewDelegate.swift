//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import EffortModel

public protocol RankViewDelegate: AnyObject {
  func rankView(_ rankView: RankView, didSelectRank rank: Rank)
}
