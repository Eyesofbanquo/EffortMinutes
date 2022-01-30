//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/29/22.
//

import Foundation

public protocol BottomNavigationBarItemDelegate: AnyObject {
  func mainTabBarItem(_ item: BottomNavigationBarItem, didSelectIndex index: Int)
}
