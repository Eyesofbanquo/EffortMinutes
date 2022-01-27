//
//  RankViewController.swift
//  CircleBuns
//
//  Created by Markim Shaw on 1/12/22.
//

import Foundation
import UIKit

final class RankViewController: UIViewController {
  
  static var scrollViewScaleFactor: CGFloat = 0.01
  static var maxValue: CGFloat = 300000.0 * scrollViewScaleFactor
  
  var scrollView: UIScrollView!
  lazy var contentView: UIView = UIView()
  lazy var detailTransitioningDelegate: RankDetailTransitioningDelegate = RankDetailTransitioningDelegate()
  lazy var ranks: [Rank] = Rank.allCases
  
  /* Make its own view */
  lazy var progressBall: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    var path = UIBezierPath()
    path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 22, height: 22))
    
    let shape = CAShapeLayer()
    shape.path = path.cgPath
    shape.fillColor = UIColor(hexString: "#80CED7").cgColor
    shape.lineWidth = 1.0
    
    let pulseShape = CAShapeLayer()
    pulseShape.path = path.cgPath
    pulseShape.fillColor = UIColor(hexString: "#80CED7").cgColor
    pulseShape.lineWidth = 1.0
    
    let basicAnimation = CABasicAnimation(keyPath: "transform.scale")
    basicAnimation.duration = 1.0
    basicAnimation.fromValue = 1
    basicAnimation.toValue = 1.25
    basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    basicAnimation.autoreverses = true
    basicAnimation.repeatCount = .greatestFiniteMagnitude
    
    let animation2 = CABasicAnimation(keyPath: "position")
    animation2.duration = 1.0
    animation2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation2.fromValue = CGPoint(x: view.bounds.size.width/2, y: (view.bounds.size.height/2))
    animation2.toValue = CGPoint(x: view.bounds.size.width/2, y: (view.bounds.size.height/2))
    
//    [toBeMask.layer.mask addAnimation:animation2 forKey:@"animateMask2"];
//
//    view.layer.addSublayer(pulseShape)
//    pulseShape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//    pulseShape.contentsGravity = .center
//
//    pulseShape.add(basicAnimation, forKey: "pulse")
//    pulseShape.add(animation2, forKey: "pos")
    view.layer.addSublayer(shape)
    
    return view
  }()
  
  lazy var progressInfoView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = false
    view.layer.cornerRadius = 8.0
    view.backgroundColor = .white
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "You have 800 EM"
    
    view.addSubview(label)
    
    label.snp.makeConstraints { make in
      make.leading.top.equalTo(view).offset(8.0)
      make.trailing.bottom.equalTo(view).offset(-8.0)
    }
    view.transform.rotated(by: .pi)
    view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    view.alpha = 0.0
    return view
  }()
  
  var rankViews: [IndexPath: RankView] = [:]
  
  override func loadView() {
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
  
  override func viewDidLoad() {
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
    layoutProgressBall(forValue: 800)
    
    progressBall.isUserInteractionEnabled = true
    let ballTap = UITapGestureRecognizer(target: self, action: #selector(self.handleProgressBallTap(_:)))
    progressBall.addGestureRecognizer(ballTap)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
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
  
  private func layoutProgressBall(forValue value: Double) {
    let position = weightedPercentCompletePosition(forValue: value)
    
    /* Insert it between line and `rankview`s */
    contentView.insertSubview(progressBall, at: 1)
    
    progressBall.snp.makeConstraints { make in
      make.centerX.equalTo(contentView)
      make.height.width.equalTo(22)
      make.centerY.equalTo(contentView.snp.top).offset(position)
    }
    
  }
  
  @objc func handleProgressBallTap(_ sender: UITapGestureRecognizer) {
    print("Tapped info")
    
    if progressInfoView.superview == nil {
      contentView.insertSubview(progressInfoView, at: 1)
      progressInfoView.snp.makeConstraints { make in
        make.trailing.equalTo(progressBall.snp.leading).offset(-8.0)
        make.centerY.equalTo(progressBall)
      }
      self.progressInfoView.transform =  CGAffineTransform(rotationAngle: .pi).scaledBy(x: 0.1, y: 0.1)

      UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 1.0, options: .curveEaseOut) {
        self.progressInfoView.alpha = 1.0
        self.progressInfoView.transform = CGAffineTransform(rotationAngle: .pi)
        
      } completion: { _ in

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
    
    let percentCompletePositionBasedOnView = (distanceBetweenRankViews * percentCompleteBasedOnRank) + rankViewPosition
    
    return percentCompletePositionBasedOnView
  }
}

extension RankViewController: RankViewDelegate {
  
  func rankView(_ rankView: RankView, didSelectRank rank: Rank) {
    print("Rank pressed", rank.displayName, "frame", rankView.frame)
    let screenCoordinates = rankView.convert(rankView.frame, to: self.view)
    let nextVC = RankDetailViewController(rank: rank)
    nextVC.transitioningDelegate = detailTransitioningDelegate
    detailTransitioningDelegate.setRankViewFrame(rankView.frame)
    nextVC.modalPresentationStyle = .custom
    self.present(nextVC, animated: true, completion: nil)
  }
  
  
}
