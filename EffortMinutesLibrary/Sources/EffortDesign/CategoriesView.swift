//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/1/22.
//

import Foundation
import UIKit
import SnapKit
import EffortModel

public class CategoriesViewCell: UITableViewCell {
  public static var reuseIdentifier: String = "CategoriesViewCell"
}

public class CategoriesView: UIView {
  
  // MARK: - Properties -
  
  /// This delegate will handle the `UITableViewDelegate` actions from the object that contains this view.
  public weak var delegate: CategoriesViewDelegate?
  
  /// This replaces `UITableViewDataSource` using the new `UITableView` API.
  private var dataSource: UITableViewDiffableDataSource<EMCategorySection, EMCategory>
  
  // MARK: - Subviews -
  private let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
  
  // MARK: - Initializer -
  
  /// Initializes an `CategoriesView` object and immediately sets up a `UITableView` view that will display `EMCategory` objects
  required public init(backgroundColor: UIColor = .white) {
    tableView.register(CategoriesViewCell.self, forCellReuseIdentifier: CategoriesViewCell.reuseIdentifier)
    tableView.backgroundColor = .init(hexString: "#63C7B2")
    dataSource = UITableViewDiffableDataSource<EMCategorySection, EMCategory>(tableView: tableView) { tableView, indexPath, itemIdentifier in
      let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesViewCell.reuseIdentifier, for: indexPath)
      cell.textLabel?.text = itemIdentifier.name
      // configure cell
      
      return cell
    }
    super.init(frame: .zero)
    
    tableView.delegate = self
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.leading.trailing.bottom.top.equalTo(self.safeAreaLayoutGuide)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CategoriesView: CategoriesViewControllerDelegate {
  public var projection: AnyObject {
    self
  }
  

  /// This function allows you to add/remove a single `EMCategory` entity.
  /// - Parameters:
  ///   - action: `remove`/`add` `EMCategory` objects.
  ///   - category: The category to add
  public func performAction(_ action: CategoriesViewDelegateAction, forCategory category: EMCategory) {
    switch action {
      case .add:
        /* Make sure to add item to actual data source BEFORE calling this */
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([category], toSection: .all)
        dataSource.apply(snapshot)
      case .remove:
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([category])
        dataSource.apply(snapshot)
    }
  }
  
  /// This function is the equivalent of `UITableView.reload()`.
  public func reload() {
    var snapshot = NSDiffableDataSourceSnapshot<EMCategorySection, EMCategory>()
    snapshot.appendSections([.all])
    if let categories = delegate?.categories {
      snapshot.appendItems(categories, toSection: .all)
    }
    dataSource.apply(snapshot)
  }
}

extension CategoriesView: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let selectedCategory = delegate?.categories[indexPath.row] else { return }
    delegate?.categoryView(self, didSelectCategory: selectedCategory)
  }
}
