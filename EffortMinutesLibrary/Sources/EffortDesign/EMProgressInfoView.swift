//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/29/22.
//

import Foundation
import UIKit
import SnapKit

public class EMProgressInfoView: UIView {
  
  private(set) var label: UILabel
  
  public init(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 8.0) {
    self.label = UILabel()

    super.init(frame: .zero)
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = false
    view.layer.cornerRadius = cornerRadius
    view.backgroundColor = backgroundColor
    
    self.label.translatesAutoresizingMaskIntoConstraints = false
    self.label.numberOfLines = 0
    self.label.lineBreakMode = .byWordWrapping
    
    view.addSubview(self.label)
    
    self.label.snp.makeConstraints { make in
      make.leading.top.equalTo(view).offset(8.0)
      make.trailing.bottom.equalTo(view).offset(-8.0)
    }
    
    addSubview(view)
    view.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalTo(self)
    }
  }
  
  public func setText(_ text: String?) {
    self.label.text = text
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
