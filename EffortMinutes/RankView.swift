//
//  RankView.swift
//  CircleBuns
//
//  Created by Markim Shaw on 1/14/22.
//

import Foundation
import UIKit

protocol RankViewDelegate: AnyObject {
  func rankView(_ rankView: RankView, didSelectRank rank: Rank)
}

final class RankView: UIView {
  
  private lazy var button: UIButton = UIButton(type: .system)
  private let rank: Rank
  private let size: CGSize
  private weak var delegate: RankViewDelegate?
  
  init(rank: Rank,
       size: CGSize,
       delegate: RankViewDelegate? = nil) {
    self.rank = rank
    self.size = size
    self.delegate = delegate
    super.init(frame: .zero)
    
//    backgroundColor = .red
    
    /* Add Subviews */
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = rank.displayName
    
    button.isUserInteractionEnabled = true
    button.translatesAutoresizingMaskIntoConstraints = false
    var configuration = UIButton.Configuration.filled()
    configuration.title = rank.displayName
    configuration.subtitle = "\(rank.range.lowerBound) EM \(rank == .warlord ? "" : "- \(rank.range.upperBound) EM")"
    configuration.titleAlignment = .center
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    configuration.baseBackgroundColor = .init(hexString: "#8E6C88")
    configuration.cornerStyle = .small
    
    
    button.configuration = configuration
    button.addAction(
      UIAction { [weak self] _ in
        guard let `self` = self else { return }
        self.delegate?.rankView(self, didSelectRank: rank)
      }, for: .touchUpInside
    )
    /* Add Constraints */
    self.addSubview(button)
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor)])
    
    button.setNeedsLayout()
    button.layoutIfNeeded()
    
    self.clipsToBounds = false
    
    /* Add Gesture */
//    button.addTarget(self, action: #selector(self.buttonPressed(_:forEvent:)), for: .touchUpInside)
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: button.frame.width, height: button.frame.height)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func buttonPressed(_ sender: UIButton, forEvent event: UIEvent) {
    
  }
}
