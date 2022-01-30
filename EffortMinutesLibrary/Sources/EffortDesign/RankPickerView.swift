//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
//import EffortPresentation
import EffortModel
import UIKit
import SnapKit

class RankPickerTableViewCell: UITableViewCell {
  static var reuseIdentifier: String = "RankPickerTableViewCell"
  private var label: UILabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    label.snp.makeConstraints { make in
      make
        .leading
        .top
        .equalTo(self).offset(8.0)
      make
        .bottom
        .equalTo(self).offset(-8.0)
    }
    
    label.font = .preferredFont(forTextStyle: .headline)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(fromCategory category: EMCategory) {
    self.label.text = category.name
  }
  
  override func prepareForReuse() {
    self.label.text = ""
  }
}

public class RankPickerView: UIView {
  
  enum State {
    case open, closed
  }
  
  // MARK: - Properties -
  private var state: State = .closed
  
  // MARK: - Views -
  private var dimmerView: UIView = UIView()
  private(set) var tableView: UITableView = UITableView()
  
  
  // MARK: - Properties -
  private var categories: [EMCategory] = []
  private var categoryOverflow: [EMCategory] = []
  public var focusedCategory: EMCategory?
  public weak var delegate: RankPickerViewDelegate?
  
  // MARK: - Init -
  public init(categories: [EMCategory] = []) {
    super.init(frame: .zero)
    
    if categories.count > 1, let firstCategory = categories.first {
      self.focusedCategory = firstCategory
      self.categories = [firstCategory]
      self.categoryOverflow = categories.filter { $0.name.lowercased() != firstCategory.name.lowercased() }
    } else {
      self.categories = categories
    }
    
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
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setView(forState state: State) {
    
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
//
//    self.setNeedsLayout()
//    self.layoutIfNeeded()

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
  
  override public func layoutSubviews() {
    super.layoutSubviews()
//    self.invalidateIntrinsicContentSize()
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
