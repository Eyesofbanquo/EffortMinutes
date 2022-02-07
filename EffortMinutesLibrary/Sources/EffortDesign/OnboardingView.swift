//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/5/22.
//

import Foundation
import UIKit
import SnapKit
import EffortModel



public class OnboardingView: UIView, OnboardingViewControllerDelegate {
  
  enum State {
    case intro, prompt, form, finish
    
    var duration: CGFloat { 0.8 }
    
    var delay: CGFloat {
      switch self {
        case .intro: return 0
        case .prompt: return 1.0 + duration
        case .form: return 2.0 + (duration * 2)
        case .finish: return duration
      }
    }
  }
  
  public var projectedView: UIView? {
    self
  }
  
  public weak var viewDelegate: OnboardingViewDelegate?
  
  // MARK: - Properties -
  
  private var mainStackView: UIStackView = UIStackView()
  private var categoryStackView: UIStackView = UIStackView()
  private var introLabel: UILabel = UILabel()
  private var promptLabel: UILabel = UILabel()
  private var categoryTitle: UILabel = UILabel()
  private var categoryLabel: UILabel = UILabel()
  private var categoryRank: UILabel = UILabel()
  private var categoryMinutes: UILabel = UILabel()
  private var finishButton: UIButton = UIButton()
  private var createCategoryForm: CreateCategoryForm!
  private var state: State = .intro
  
  // MARK: - Init -
  required public init() {
    super.init(frame: .zero)
    
    createCategoryForm = CreateCategoryForm(onCreateAction: { [unowned self] categoryName in
      self.viewDelegate?.onboardingViewDelegate(self, didAddCategoryWithName: categoryName)
    })
    
    backgroundColor = .white
    
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    setupLabel(label: introLabel)
    setupLabel(label: promptLabel)
    setupLabel(label: categoryLabel)
    setupLabel(label: categoryRank)
    setupLabel(label: categoryMinutes)
    setupLabel(label: categoryTitle)
    setupFinishButton()
    
    /* This is the second part */
    categoryStackView.translatesAutoresizingMaskIntoConstraints = false
    categoryStackView.addArrangedSubview(categoryTitle)
    categoryStackView.addArrangedSubview(categoryLabel)
    categoryStackView.addArrangedSubview(categoryMinutes)
    categoryStackView.addArrangedSubview(categoryRank)
    categoryStackView.axis = .vertical
    categoryStackView.alignment = .leading
    categoryStackView.distribution = .fill
    categoryStackView.spacing = 4.0
    
    introLabel.text = "Welcome to EM where we will guide you through building future habits and routines."
    promptLabel.text = "All you need to do to begin is create your first category!"
    categoryTitle.text = "Your newly created category!"
    categoryTitle.font = .preferredFont(forTextStyle: .headline)
    categoryLabel.text = "You created the category - READING"
    categoryMinutes.text = "Which starts with - 0 EM"
    categoryRank.text = "Which starts at rank - ROOKIE"
    
    
    /* This is the entire stack view*/
    mainStackView.axis = .vertical
    mainStackView.alignment = .fill
    mainStackView.distribution = .fill
    mainStackView.spacing = 32.0
    mainStackView.addArrangedSubview(introLabel)
    mainStackView.addArrangedSubview(promptLabel)
    mainStackView.addArrangedSubview(createCategoryForm)
    mainStackView.addArrangedSubview(categoryStackView)
    addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.bottom.lessThanOrEqualTo(self.finishButton.snp.top).offset(-32.0)
      make.leading.equalTo(self.safeAreaLayoutGuide).offset(16.0)
      make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16.0)
      make.top.equalTo(self.safeAreaLayoutGuide).offset(32.0)
    }
    
    introLabel.layer.opacity = 0
    promptLabel.layer.opacity = 0
    createCategoryForm.layer.opacity = 0.0
    categoryStackView.layer.opacity = 0.0
    finishButton.layer.opacity = 0.0
  }
  
  public required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Private Actions -
  private func setupLabel(label: UILabel) {
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
  }
  
  private func setupFinishButton() {
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Finish"
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    configuration.baseBackgroundColor = .init(hexString: "#07A0C3")
    configuration.baseForegroundColor = .white
    configuration.background.cornerRadius = 4.0
    
    finishButton.configuration = configuration
    finishButton.addAction(UIAction(handler: { [unowned self] _ in
      self.viewDelegate?.onboardingViewDelegateShouldDismiss(self)
    }), for: .touchUpInside)
    
    finishButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(finishButton)
    
    finishButton.setContentCompressionResistancePriority(.required, for: .vertical)
    
    finishButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16.0)
      make.leading.equalTo(self.safeAreaLayoutGuide).offset(8.0)
      make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-8.0)
    }
  }
  
  public func begin() {
    UIView.animate(withDuration: state.duration, delay: state.delay, options: .curveEaseOut) {
      self.state = .prompt
      self.introLabel.layer.opacity = 1.0
      self.introLabel.setNeedsLayout()
      self.introLabel.layoutIfNeeded()
    } completion: { _ in
    }
    
    UIView.animate(withDuration: state.duration, delay: state.delay, options: .curveEaseOut) {
      self.state = .form

      self.promptLabel.layer.opacity = 1.0
      self.promptLabel.setNeedsLayout()
      self.promptLabel.layoutIfNeeded()
    } completion: { _ in
    }
    
    UIView.animate(withDuration: state.duration, delay: state.delay, options: .curveEaseOut) {
      self.state = .finish

      self.createCategoryForm.layer.opacity = 1.0
      self.createCategoryForm.setNeedsLayout()
      self.createCategoryForm.layoutIfNeeded()
    } completion: { _ in
    }
  }
  
  public func onboardingViewControllerDelegate(_ delegate: OnboardingViewDelegate, didReceiveCategory category: EMCategory) {
    createCategoryForm.isEnabled = false
    
    categoryLabel.text = "Name: \(category.name)"
    let rank = Rank(rankValue: Double(category.effortMinutes))
    categoryRank.text = "Current Rank: \(rank.displayName)"
    categoryMinutes.text = "Effort Minutes: \(category.effortMinutes) EM"
    
    /* Display the second part of the stack */
    UIView.animate(withDuration: state.duration, delay: 1.0, options: .curveEaseOut) {
      self.categoryStackView.layer.opacity = 1.0
      self.categoryStackView.setNeedsLayout()
      self.categoryStackView.layoutIfNeeded()
    }
    
    /* Display a little description of the bs at the end like pokemon*/
    
    /* Finally show the finish button */
    UIView.animate(withDuration: state.duration, delay: state.duration + 2.0, options: .curveEaseOut) {
      self.finishButton.layer.opacity = 1.0
    }
  }
}
