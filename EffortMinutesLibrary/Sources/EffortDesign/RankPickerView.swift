//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import EffortModel
import UIKit
import SnapKit
import RealmSwift

public class RankPickerView: UIView {
  
  enum State {
    case open, closed
  }
  
  // MARK: - Views -
  private var dimmerView: UIView = UIView()
  private(set) var tableView: UITableView = UITableView()
  
  
  // MARK: - Properties -
  private var state: State = .closed
  private var categories: [EMCategory] = []
  private var categoryOverflow: [EMCategory] = []
  private var store: Store
  private var notificationToken: NotificationToken?
  public var focusedCategory: EMCategory?
  public weak var delegate: RankPickerViewDelegate?
  
  // MARK: - Init -
  public init(store: Store) {
    self.store = store
    super.init(frame: .zero)
    
    self.setupCategories()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make
        .leading
        .trailing
        .bottom
        .top
        .equalTo(self)
    }
    tableView.register(RankPickerTableViewCell.self, forCellReuseIdentifier: RankPickerTableViewCell.reuseIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    
    /* Respond to changes to the realm collection */
    notificationToken = store.categories.observe { [weak self] changes in
      switch changes {
        case .update:
          self?.setupCategories()
        default: break
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    notificationToken?.invalidate()
    notificationToken = nil
  }
  
  private func setView(forState state: State) {
    
  }
  
  private func setupCategories() {
    let categories = Array(self.store.categories)
    if categories.count > 1, let firstCategory = categories.first?.structured {
      self.focusedCategory = firstCategory
      self.categories = [firstCategory]
      self.categoryOverflow = Array(categories.filter { $0.name.lowercased() != firstCategory.name.lowercased() }.map { $0.structured })
    } else {
      self.categories = Array(categories.map { $0.structured })
    }
  }
  
  public func open() {
    var addedIndexPaths: [IndexPath] = []
    for (index, _) in categoryOverflow.enumerated() {
      addedIndexPaths.append(IndexPath(row: index + 1, section: 0))
    }
    tableView.beginUpdates()
    self.categories.append(contentsOf: categoryOverflow)
    tableView.insertRows(at: addedIndexPaths, with: .bottom)
    tableView.endUpdates()
    state = .open
  }
  
  public func close(category: EMCategory) {
    state = .closed
    var indexPathsToRemove: [IndexPath] = []
    let categoryOverflow = self.categories.filter { $0.name.lowercased() != category.name.lowercased()}
    tableView.beginUpdates()
    self.categories = [category]
    for (index, _) in categoryOverflow.enumerated() {
      indexPathsToRemove.append(IndexPath(row: index + 1, section: 0))
    }
    tableView.deleteRows(at: indexPathsToRemove, with: .top)
    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RankPickerTableViewCell
    cell?.configure(fromCategory: category)
    
    tableView.endUpdates()
    self.categoryOverflow = categoryOverflow
    self.focusedCategory = category
//    self.setNeedsLayout()
//    self.layoutIfNeeded()
    
   
  }
  
  override public var intrinsicContentSize: CGSize {
    get {
      var height:CGFloat = 0;
      for section in 0..<tableView.numberOfSections {
        let nRowsSection = tableView.numberOfRows(inSection: section)
        for row in 0..<nRowsSection {
          height += tableView.rectForRow(at: IndexPath(row: row, section: section)).size.height
        }
      }
      return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    set {
    }
  }
  
}

extension RankPickerView: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RankPickerTableViewCell.reuseIdentifier, for: indexPath)
    guard let pickerCell = cell as? RankPickerTableViewCell else { return cell }
    
    pickerCell.configure(fromCategory: categories[indexPath.row])
    
    return pickerCell
  }
}

extension RankPickerView: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if state == .closed {
      self.open()

      UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut) {
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
        self.layoutIfNeeded()
      }

    } else if state == .open {
      let selectedCategory = self.categories[indexPath.row]
      self.close(category: self.categories[indexPath.row])
      self.delegate?.rankPickerView(self, didSelectCategory: selectedCategory)
      UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn) {
        self.invalidateIntrinsicContentSize()

        
        self.setNeedsLayout()
        self.layoutIfNeeded()
      }
    }
  }
}
