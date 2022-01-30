//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import UIKit
import EffortDesign
import EffortPresentation
import EffortModel

public final class RankViewController: UIViewController {
  
  static var scrollViewScaleFactor: CGFloat = 0.01
  static var maxValue: CGFloat = 300000.0 * scrollViewScaleFactor
  
  var scrollView: UIScrollView!
  lazy var contentView: UIView = UIView()
  lazy var detailTransitioningDelegate: GenericTransitioningDelegate = GenericTransitioningDelegate(presentation: PopPresentAnimation(), dismissal: PopDismissAnimation())
  
  /* This is for displaying all ranks */
  lazy var ranks: [Rank] = Rank.allCases
  
  /* Make its own view */
  lazy var progressBall: BallView = BallView()
  lazy var biggerProgressBall: BallView = BallView(size: CGSize(width: 44, height: 44), opacity: 0.5)
  
  lazy var progressInfoView: EMProgressInfoView = EMProgressInfoView()
  
  var rankViews: [IndexPath: RankView] = [:]
  
  var category: EMCategory!
  
  override public func loadView() {
    /* Scroll view*/
    scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    /* Content view for the scroll view*/
    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentView)
    
    /* This is the view for RankViewController */
    let rankView = UIView()
    rankView.translatesAutoresizingMaskIntoConstraints = false
    rankView.backgroundColor = .init(hexString: "#CCDBDC")
    
    rankView.addSubview(scrollView)
    
    self.view = rankView
    
    self.view.setNeedsLayout()
    self.view.layoutIfNeeded()
    
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    
    scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    
    /* Rotate ScrollView so it starts scrolling from the bottom */
    scrollView.transform = scrollView.transform.rotated(by: .pi)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    /* Create line */
    let topLine = LineView(maxValue: Self.maxValue, lineWidth: 5.0, strokeColor: .white)
    topLine.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(topLine)
    topLine.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    topLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    topLine.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    topLine.heightAnchor.constraint(equalToConstant: Self.maxValue).isActive = true
    
    
    
    /* Force layout to give scrollview its frame */
    self.view.setNeedsLayout()
    self.view.layoutIfNeeded()
    
    /* Layout the rank views */
    layoutRankViews()
    scrollView.setNeedsLayout()
    scrollView.layoutIfNeeded()
//    layoutProgressBall(forValue: 800)
    
    let ballTap = UITapGestureRecognizer(target: self, action: #selector(self.handleProgressBallTap(_:)))
    progressBall.addGestureRecognizer(ballTap)
  }
  
  private func layoutRankViews() {
    let sideDimensions: CGFloat = self.view.bounds.height * 0.20
    let rankViewSize: CGSize = CGSize(width: sideDimensions, height: sideDimensions)
    
    let divisions = CGFloat(Self.maxValue) / CGFloat(ranks.count - 1)
    print(divisions)
    
    for (index, rank) in ranks.enumerated() {
      let rankView = RankView(rank: rank,
                              size: rankViewSize,
                              delegate: self)
      rankView.translatesAutoresizingMaskIntoConstraints = false
      
      contentView.addSubview(rankView)
      rankView.setNeedsLayout()
      rankView.layoutIfNeeded()
      rankViews[IndexPath(item: index, section: 0)] = rankView
      
      let calc = (rank == .warlord ? -rankView.frame.size.height / 2 : rankView.frame.size.height / 2) + ((divisions * CGFloat(index)) )
      
      NSLayoutConstraint.activate([
        rankView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                          constant: calc),
        rankView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)])
      rankView.transform = rankView.transform.rotated(by: .pi)
      rankView.layer.shouldRasterize = true
      rankView.layer.rasterizationScale = UIScreen.main.scale
    }
  }
  
  public func setEMCategory(_ category: EMCategory) {
    self.category = category
    layoutProgressBall(forValue: Double(category.effortMinutes))
    progressInfoView.setText("You have \(category.effortMinutes) minutes!")
  }
  
  private func layoutProgressBall(forValue value: Double) {
    let position = weightedPercentCompletePosition(forValue: value)
    biggerProgressBall.translatesAutoresizingMaskIntoConstraints = false
    /* Insert it between line and `rankview`s */
    contentView.insertSubview(progressBall, at: 1)
    
    progressBall.snp.remakeConstraints { make in
      make.centerX.equalTo(contentView)
      make.centerY.equalTo(contentView.snp.top).offset(position)
    }
    
    contentView.insertSubview(biggerProgressBall, at: 1)
    biggerProgressBall.snp.remakeConstraints { make in
      make.centerX.equalTo(contentView)
      make.centerY.equalTo(contentView.snp.top).offset(position)
    }
    self.biggerProgressBall.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat]) {
      self.biggerProgressBall.transform = .identity
    }

    progressBall.setNeedsLayout()
    progressBall.layoutIfNeeded()
    let windowPosition = scrollView.convert(progressBall.frame.origin, to: nil)
    scrollView.setContentOffset(CGPoint(x: 0.0, y: position), animated: true)
    let window = UIScreen.main.bounds
    if abs(window.height / 2 - windowPosition.y) > 0 {
      scrollView.contentOffset.y -= window.height / 2
    }
    
    print(windowPosition)
    
  }
  
  @objc func handleProgressBallTap(_ sender: UITapGestureRecognizer) {
    print("Tapped info")
    
    if progressInfoView.superview == nil {
      progressInfoView.transform.rotated(by: .pi)
      progressInfoView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      progressInfoView.alpha = 0.0
      contentView.insertSubview(progressInfoView, at: 100)
      
      progressInfoView.snp.makeConstraints { make in
        make.trailing.equalTo(progressBall.snp.leading).offset(-8.0)
        make.leading.greaterThanOrEqualToSuperview()
        make.centerY.equalTo(progressBall)
      }
      self.progressInfoView.transform =  CGAffineTransform(rotationAngle: .pi).scaledBy(x: 0.1, y: 0.1)
      
      UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 1.0, options: .curveEaseOut) {
        self.progressInfoView.alpha = 1.0
        self.progressInfoView.transform = CGAffineTransform(rotationAngle: .pi)
      }
    } else {
      UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.67, initialSpringVelocity: 1.0, options: .curveEaseIn) {
        self.progressInfoView.alpha = 0.0
        self.progressInfoView.transform = CGAffineTransform(rotationAngle: .pi).scaledBy(x: 0.1, y: 0.1)
      } completion: { _ in
        self.progressInfoView.removeFromSuperview()
      }
    }
    
  }
  
  private func percentComplete(forValue value: Double) -> Double {
    /* First find where this number lies in the diagram by finding its rank */
    let associatedRank: Rank = Rank(rankValue: value)
    
    /* Get the next rank */
    guard let nextRank = associatedRank + 1 else { return 0.0 }
    
    let offset = value - Double(associatedRank.range.lowerBound)
    
    /* FInd the distance between ranks*/
    let distanceBetweenRanks = nextRank.range.lowerBound - associatedRank.range.lowerBound
    
    /* Find the percent of the current value */
    return (offset / Double(distanceBetweenRanks))
  }
  
  private func weightedPercentCompletePosition(forValue value: Double) -> CGFloat {
    /* Retrieve the associated rank*/
    let associatedRank: Rank = Rank(rankValue: value)
    
    /* Use this rank to find the index */
    guard let associatedRankIndex = ranks.firstIndex(of: associatedRank),
          let rankView = rankViews[IndexPath(item: associatedRankIndex, section: 0)]
    else { return 0.0 }
    
    /* Find the rank view position */
    let rankViewPosition = rankView.center.y + rankView.frame.height / 2.0
    
    guard associatedRankIndex + 1 < ranks.count,
          let nextRankView = rankViews[IndexPath(item: associatedRankIndex + 1, section: 0)]
    else { return 0.0 }
    
    /* Find next rank view position */
    let nextRankPosition = nextRankView.center.y - nextRankView.frame.height / 2.0
    
    let distanceBetweenRankViews = nextRankPosition - rankViewPosition
    let percentCompleteBasedOnRank = percentComplete(forValue: value)
    
    /* Find the new position based on start position + % distance between start-end positions*/
    let percentCompletePositionBasedOnView = (distanceBetweenRankViews * percentCompleteBasedOnRank) + rankViewPosition
    
    return percentCompletePositionBasedOnView
  }
}

extension RankViewController: RankViewDelegate {
  
  public func rankView(_ rankView: RankView, didSelectRank rank: Rank) {
    let nextVC = RankDetailViewController(rank: rank)
    nextVC.transitioningDelegate = detailTransitioningDelegate
    nextVC.modalPresentationStyle = .custom
    self.present(nextVC, animated: true, completion: nil)
  }
  
  
}
