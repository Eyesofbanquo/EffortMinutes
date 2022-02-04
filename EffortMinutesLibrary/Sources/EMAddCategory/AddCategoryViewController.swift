//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/31/22.
//

import Foundation
import UIKit
import SnapKit
import EffortDesign
import EffortModel



public class AddCategoryViewController: UIViewController {
  
  // MARK: - Properties -
  var store: Store
  
  // MARK: - Views -
  var nameTextField: UITextField = UITextField()
  
  // MARK: - Init -
  internal init(store: Store) {
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
    
    /* Add Button bar item for AddCat */
    let saveCategoryButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveCategory))
    
    self.navigationItem.rightBarButtonItems = [saveCategoryButton]
    
    add(field: nameTextField)
    nameTextField.placeholder = "Enter Category Name"
    nameTextField.snp.makeConstraints { make in
      make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16.0)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16.0)
      make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16.0)
    }
    
  }
  
  @objc func saveCategory() {
    
    /* Validate */
    guard nameTextField.text?.isEmpty == false, let text = nameTextField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) else { return }
    
    #if FRAMEWORK
    let newCategory = EMCategory(id: 4, name: text, effortMinutes: 0)
    try? (store as? DataMapper)?.addCategory(newCategory, atIndex: 4)
    print("Ok")
    #else
    let newCategory = EMCategory(id: 0, name: text, effortMinutes: 0)
    try? store?.addCategory(newCategory)
    #endif
    
    /* Return to category page */
    self.navigationController?.popViewController(animated: true)
  }
  
  func add(field: UITextField) {
    field.translatesAutoresizingMaskIntoConstraints = false
    field.delegate = self
    view.addSubview(field)
  }
}

extension AddCategoryViewController: UITextFieldDelegate {
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
      case nameTextField:
        nameTextField.becomeFirstResponder()
      default:
        break
    }
    
    return true
  }
}
