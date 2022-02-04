//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/4/22.
//

import Foundation
import UIKit
import SnapKit

public protocol RankDisplayBarViewDelegate: AnyObject {
  func rankDisplayBarView(_ bar: RankDisplayBarView, didSelectView: Bool)
}

public class RankDisplayBarView: UIView {
  
  var categoryLabel: UILabel = UILabel()
  
  public weak var delegate: RankDisplayBarViewDelegate?
  
  public init() {
    super.init(frame: .zero)
    
    backgroundColor = .init(hexString: "#63C7B2")
    
    categoryLabel.translatesAutoresizingMaskIntoConstraints = false
    categoryLabel.textColor = .white
    addSubview(categoryLabel)
    categoryLabel.snp.makeConstraints { make in
      make.leading.top.equalTo(self).offset(16.0)
      make.bottom.trailing.equalTo(self).offset(-16.0)
    }
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTap(_:)))
    self.addGestureRecognizer(tapGesture)
  }
  
  @objc func didTap(_ gesture: UITapGestureRecognizer) {
    delegate?.rankDisplayBarView(self, didSelectView: true)
  }
  
  public func setCategory(_ text: String) {
    self.categoryLabel.text = text
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
