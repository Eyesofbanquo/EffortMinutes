//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/31/22.
//

import Foundation
import UIKit
import EffortModel
import EffortDesign
import SnapKit
import Realm
import RealmSwift

public class CategoriesViewController: UIViewController {
  
  // MARK: - Properties -
  var store: Store
  
  lazy var searchController: UISearchController = {
    let controller = UISearchController(searchResultsController: nil)
    controller.searchResultsUpdater = self
    controller.obscuresBackgroundDuringPresentation = false
    controller.searchBar.placeholder = "Search Categories"
    controller.searchBar.tintColor = .white
    if let textfield = controller.searchBar.value(forKey: "searchField") as? UITextField {
      textfield.textColor = UIColor.white
    }
//    if let textfield = controller.searchBar.value(forKey: "searchField") as? UITextField {
//      textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
//    }
//    definesPresentationContext = true
    return controller
  }()
  
  /// When initialized this will listen to `ALL` `EMCategoryRO` objects from the `Realm` and it will update this table automatically.
  lazy var notifier: EMNotifier<EMCategoryRO> = EMNotifier<EMCategoryRO>(realm: store.realm)
  
  var viewControllerDelegate: CategoriesViewControllerDelegate
  
  var onSelect: ((EMCategory) -> Void)?
  
  // MARK: - Init -
  internal init(object: CategoriesViewControllerDelegate.Type,
                store: Store,
                onSelect: ((EMCategory) -> Void)? = nil) {
    self.store = store
    self.viewControllerDelegate = object.init(backgroundColor: .white)
    self.onSelect = onSelect
    super.init(nibName: nil, bundle: nil)
    self.notifier.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle -
  
  override public func loadView() {
    guard let view = viewControllerDelegate.projection as? CategoriesView else {
      super.loadView()
      return
    }
    
    view.delegate = self
    
    self.view  = view
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .init(hexString: "#63C7B2")
    
    /* Add Button bar item for AddCat */
    setupNavigationBar()
    
    viewControllerDelegate.reload()
  }
  
  deinit {
    notifier.scheduleDeinit()
  }
  
  // MARK: - Actions -
  @objc private func launchAddCategory() {
    let addCategoryController = AddCategoryViewController(store: store)
    self.navigationController?.pushViewController(addCategoryController, animated: true)
  }
  
  private func launchEditCategory(forCategory category: EMCategory) {
    let editCategoryController = EditCategoryViewController(category: category, store: store)
    self.navigationController?.pushViewController(editCategoryController, animated: true)
  }
  
  // MARK: - Private API -
  
  private func setupNavigationBar() {
    let addCategoryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.launchAddCategory))
    self.navigationItem.rightBarButtonItems = [addCategoryButton]
    self.navigationItem.searchController = searchController
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationItem.hidesSearchBarWhenScrolling = false
  }
}

extension CategoriesViewController: CategoriesViewDelegate {
  
  public var categories: [EMCategory] {
    guard searchController.searchBar.text?.isEmpty == false else {
      return store.categories.map { $0.structured }
    }
    return store.categories.map { $0.structured }.filter { category in
      guard let searchableText = searchController.searchBar.text else { return true }
      return category.name.lowercased().contains(searchableText.lowercased())
    }
  }
  
  public func categoryView(_ categoryView: CategoriesViewControllerDelegate, didSelectCategory category: EMCategory) {
    /* Remove category. This should auto update the realm */
    launchEditCategory(forCategory: category)
    onSelect?(category)
  }
  
}

extension CategoriesViewController: EMNotifierDelegate  {
  public func emNotifier<T>(_ notifier: EMNotifier<T>, didReceiveInitialResults results: [T]) {
//    let results = results.compactMap { $0 as? EMCategoryRO }
  }
  
  public func emNotifier<T>(_ notifier: EMNotifier<T>, didReceiveUpdate results: [T], deletions: [Int], insertions: [Int], modifications: [Int]) {
//    let results = results.compactMap { $0 as? EMCategoryRO }
    viewControllerDelegate.reload()
  }
  
  public func emNotifier<T>(_ notifier: EMNotifier<T>, didReceiveError error: EMNotifier<T>.EMNotifierError)  {
    
  }
}


extension CategoriesViewController: UISearchResultsUpdating {
  public func updateSearchResults(for searchController: UISearchController) {
    viewControllerDelegate.reload()
    print("Typing is occurring")
  }
}
