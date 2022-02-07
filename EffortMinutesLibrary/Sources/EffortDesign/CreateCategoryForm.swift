//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/7/22.
//

import Foundation
import UIKit
import SnapKit

public class CreateCategoryForm: UIView {
  
  // MARK: - Properties -
  
  /// Determines whether or not the `onCreateAction` fires. Fires when `isEnabled` is set to true.
  var isEnabled: Bool = true
  
  // MARK: - Views -
  private var addCategoryTextField: UITextField = PaddingTextField(cornerRadius: 3,
                                                                   borderWidth: 2,
                                                                   borderColor: UIColor.init(hexString: "#07A0C3").cgColor)
  private var addCategoryStackView: UIStackView = UIStackView()
  private var addCategoryLabel: UILabel = UILabel()
  private var addCategoryButton: UIButton = UIButton()
  
  // MARK: - Actions -
  var onCreateAction: (String?) -> Void
  
  // MARK: - Init -
  public init(onCreateAction: @escaping (String?) -> Void) {
    self.onCreateAction = onCreateAction
    super.init(frame: .zero)
    
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Create"
    configuration.baseBackgroundColor = .init(hexString: "#07A0C3")
    configuration.baseForegroundColor = .white
    configuration.background.cornerRadius = 4.0
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    addCategoryButton.configuration = configuration
    
    addCategoryButton.addAction(UIAction(handler: { [unowned self] _ in
      guard self.isEnabled else { return }
      self.onCreateAction(addCategoryTextField.text)
    }), for: .touchUpInside)
    
    addCategoryTextField.placeholder = "Category name"
    addCategoryLabel.text = "Create a new category"
    addCategoryLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    
    addCategoryStackView.translatesAutoresizingMaskIntoConstraints = false
    addCategoryStackView.addArrangedSubview(addCategoryLabel)
    addCategoryStackView.addArrangedSubview(addCategoryTextField)
    addCategoryStackView.addArrangedSubview(addCategoryButton)
    
    addCategoryStackView.axis = .vertical
    addCategoryStackView.alignment = .fill
    addCategoryStackView.distribution = .fill
    addCategoryStackView.spacing = 8.0
    
    addSubview(addCategoryStackView)
    addCategoryStackView.snp.makeConstraints { make in
      make.bottom.leading.trailing.top.equalTo(self)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
