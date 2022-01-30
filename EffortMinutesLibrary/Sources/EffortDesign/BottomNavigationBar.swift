//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/29/22.
//

import Foundation
import UIKit
import SnapKit

public final class BottomNavigationBar: UIView, BottomNavigationBarItemDelegate {
  
  var stackView: UIStackView
  var items: [BottomNavigationBarItem] = []
  public weak var delegate: BottomNavigationBarItemDelegate?
  var handler: BottomNavigationHandler
  
  public init() {
    stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .horizontal
    stackView.spacing = 4.0
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    
    handler = BottomNavigationHandler()
    
    super.init(frame: .zero)
    
    backgroundColor = .init(hexString: "#CCDBDC")
    
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.top.equalTo(self).offset(8.0)
      make.bottom.trailing.equalTo(self).offset(-8.0)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  public func add(item: BottomNavigationBarItem) {
    stackView.insertArrangedSubview(item, at: item.index)
    item.delegate = self
  }
  
  public func mainTabBarItem(_ item: BottomNavigationBarItem, didSelectIndex index: Int) {
    /* Do something with THIS tab bar's delegate */
    for case let tab as BottomNavigationBarItem in stackView.arrangedSubviews where tab.index != index {
      tab.deselect()
    }
    self.delegate?.mainTabBarItem(item, didSelectIndex: index)
  }
}
