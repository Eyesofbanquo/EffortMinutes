//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/30/22.
//

import Foundation
import UIKit
import EffortModel

class RankPickerTableViewCell: UITableViewCell {
  static var reuseIdentifier: String = "RankPickerTableViewCell"
  private var label: UILabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    label.snp.makeConstraints { make in
      make
        .leading
        .top
        .equalTo(self).offset(8.0)
      make
        .bottom
        .equalTo(self).offset(-8.0)
    }
    
    label.font = .preferredFont(forTextStyle: .headline)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(fromCategory category: EMCategory) {
    self.label.text = category.name
  }
  
  override func prepareForReuse() {
    self.label.text = ""
  }
}
