//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import UIKit

public enum Rank: String, CaseIterable {
  public typealias RankValue = Double
  
  static var rankModifiers = ["super", "ultra", "grand", "ultimate"]
  
  case rookie
  case bronze, superBronze, ultraBronze
  case silver, superSilver, ultraSilver
  case gold, superGold, ultraGold
  case platinum, superPlatinum, ultraPlatinum
  case diamond, superDiamond, ultraDiamond
  case master, grandMaster
  case ultimateGrandMaster = "ultimategrandmaster"
  case warlord
  
  public init(rankValue: RankValue) {
    switch rankValue {
      case 0...499: self = .rookie
      case 500...999: self = .bronze
      case 1000...1499: self = .superBronze
      case 1500...1999: self = .ultraBronze
      case 2000...2999: self = .silver
      case 3000...3499: self = .superSilver
      case 3500...3999: self = .ultraSilver
      case 4000...5499: self = .gold
      case 5500...6499: self = .superGold
      case 6500...7499: self = .ultraGold
      case 7500...9999: self = .platinum
      case 10000...11999: self = .superPlatinum
      case 12000...13999: self = .ultraPlatinum
      case 14000...19999: self = .diamond
      case 20000...24999: self = .superDiamond
      case 25000...29999: self = .ultraDiamond
      case 30000...34999: self = .master
      case 35000...99999: self = .grandMaster
      case 100000...299999: self = .ultimateGrandMaster
      default: self = .warlord
    }
  }
  
  public var displayName: String {
    switch self {
      case .rookie, .bronze, .silver, .gold, .platinum, .diamond, .warlord, .master: return self.rawValue.capitalized
      case .superBronze, .ultraBronze, .superSilver, .ultraSilver, .superGold, .ultraGold, .superPlatinum, .ultraPlatinum, .superDiamond, .ultraDiamond, .grandMaster, .ultimateGrandMaster:
        var modified: String = self.rawValue
        Self.rankModifiers.forEach { modifier in
          modified = modified.replacingOccurrences(of: modifier, with: "\(modifier) ")
        }
        let modifiedComponents = modified.components(separatedBy: " ")
        let modifiedComponentsCapitalized = modifiedComponents.map { $0.capitalized }
        let modifiedComponentsString = modifiedComponentsCapitalized.joined(separator: " ")
        return modifiedComponentsString
    }
  }
  
  public var subtitle: String {
    switch self {
      case .warlord:
        return "\(self.range.lowerBound) EM"
      default: return "\(self.range.lowerBound) EM - \(self.range.upperBound) EM"
    }
  }
  
  public var range: ClosedRange<Int> {
    switch self {
      case .rookie: return 0...499
      case .bronze: return 500...999
      case .superBronze: return 1000...1499
      case .ultraBronze: return 1500...1999
      case .silver: return 2000...2999
      case .superSilver: return 3000...3499
      case .ultraSilver: return 3500...3999
      case .gold: return 4000...5499
      case .superGold: return 5500...6499
      case .ultraGold: return 6500...7499
      case .platinum: return 7500...9999
      case .superPlatinum: return 10000...11999
      case .ultraPlatinum: return 12000...13999
      case .diamond: return 14000...19999
      case .superDiamond: return 20000...24999
      case .ultraDiamond: return 25000...29999
      case .master: return 30000...34999
      case .grandMaster: return 35000...99999
      case .ultimateGrandMaster: return 100000...299999
      default: return 300000...999999
    }
  }
  
  public var color: UIColor? {
    nil
  }
  
  public static func +(lhs: Rank, rhs: Int) -> Rank? {
    if rhs > Rank.allCases.count {
      return .warlord
    }
    
    guard let indexOfRank = Rank.allCases.firstIndex(of: lhs) else { return nil }
    
    let advancedIndex = indexOfRank.advanced(by: rhs)
    
    return Rank.allCases[advancedIndex]
  }
}
