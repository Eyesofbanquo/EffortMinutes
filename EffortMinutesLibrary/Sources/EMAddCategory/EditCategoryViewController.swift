//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/4/22.
//

import Foundation
import UIKit
import EffortDesign
import EffortModel
import SnapKit

public class EditCategoryViewController: UIViewController {
  
  // MARK: - Properties -
  let category: EMCategory
  var store: Store
  
  // MARK: - Views -
  let stackView: UIStackView = UIStackView()
  let categoryNameLabel: UILabel = UILabel()
  let categoryEffortLabel: UILabel = UILabel()
  let removeButton: UIButton = UIButton()
  
  // MARK: - init -
  public init(category: EMCategory, store: Store) {
    self.category = category
    self.store = store
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle -
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .init(hexString: "#63C7B2")
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
    categoryEffortLabel.translatesAutoresizingMaskIntoConstraints = false
    removeButton.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(categoryNameLabel)
    view.addSubview(categoryEffortLabel)
    view.addSubview(removeButton)
    
    categoryNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16.0)
      make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8.0)
    }
    
    categoryEffortLabel.snp.makeConstraints { make in
      make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16.0)
      make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8.0)
    }
    
    categoryNameLabel.text = category.name
    categoryNameLabel.textColor = .white
    categoryEffortLabel.text = "\(category.effortMinutes)"
    categoryEffortLabel.textColor = .white
    
    removeButton.snp.makeConstraints { make in
      make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16.0)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16.0)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16.0)
    }
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Remove"
    configuration.background.cornerRadius = 4.0
    configuration.background.backgroundColor = .init(hexString: "#DD1C1A")
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    removeButton.configuration = configuration
    
    removeButton.addAction(UIAction(handler: { [weak self] action in
      guard let category = self?.category else { return }
      try? self?.store.removeCategory(category)
      self?.navigationController?.popViewController(animated: true)
    }), for: .touchUpInside)
  }
}
