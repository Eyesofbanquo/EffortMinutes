//
//  MainTabBarItem.swift
//  EffortMinutes
//
//  Created by Markim Shaw on 1/18/22.
//

import Foundation
import UIKit
import SnapKit

protocol MainTabBarItemDelegate: AnyObject {
  func mainTabBarItem(_ item: MainTabBarItem, didSelectIndex index: Int)
}

final class MainTabBarItem: UIView {
  
  private(set) var index: Int
  private var stackView: UIStackView
  private var label: UILabel
  private var icon: UIImageView
  private var isSelected: Bool
  weak var delegate: MainTabBarItemDelegate?
  
  init(index: Int, icon: String, label: String) {
    stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 4.0
    
    self.label = UILabel()
    self.label.translatesAutoresizingMaskIntoConstraints = false
    self.label.text = label
    self.label.textColor = .init(hexString: "#8E6C88")
    
    self.icon = UIImageView()
    self.icon.translatesAutoresizingMaskIntoConstraints = false
    let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)
    self.icon.image = UIImage(systemName: icon, withConfiguration: config)
    self.icon.tintColor = .init(hexString: "#8E6C88")
    
    stackView.addArrangedSubview(self.icon)
    stackView.addArrangedSubview(self.label)
    
    isSelected = false
    self.label.isHidden = isSelected == false
    self.index = index
    super.init(frame: .zero)
    
    /* Add gesture recognizer */
    let gesture = UITapGestureRecognizer(target: self,
                                         action: #selector(self.handleTap(_:)))
    self.addGestureRecognizer(gesture)
    
    /* Layout stack view */
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.top.equalTo(self).offset(8.0)
      make.bottom.trailing.equalTo(self).offset(-8.0)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func deselect() {
    isSelected = false
    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut) {
      if !self.label.isHidden {
        self.label.isHidden = true
        self.icon.tintColor = .init(hexString: "#8E6C88")
        self.stackView.layoutIfNeeded()
      }
    }
  }
  
  @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
    isSelected.toggle()
    self.label.alpha = 0.0
    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut) {
      self.label.isHidden = self.isSelected == false
      self.icon.tintColor = self.isSelected ? .white : .init(hexString: "#8E6C88")
      self.stackView.layoutIfNeeded()
      self.delegate?.mainTabBarItem(self, didSelectIndex: self.index)
    }
    
    if isSelected {
      UIView.animate(withDuration: 0.1, delay: 0.25, options: .curveEaseInOut) {
        self.label.alpha = 1.0
        self.label.textColor = self.isSelected ? .white : .init(hexString: "#8E6C88")

      }
    }
  }
}
