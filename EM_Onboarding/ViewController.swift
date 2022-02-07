//
//  ViewController.swift
//  EM_Onboarding
//
//  Created by Markim Shaw on 2/5/22.
//

import UIKit
import EffortModel
import SnapKit
import RealmSwift

class ViewController: UIViewController {
  
  var notificationToken: NotificationToken?
  
  let label = UILabel()
  
  lazy var mapper: DataMapper = {
    let config = Realm.Configuration(inMemoryIdentifier: "DEBUG")
    let realm = try! Realm(configuration: config)
    let mapper = DataMapper(realm: realm)
    return mapper
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    view.backgroundColor = .white
    
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.snp.makeConstraints { make in
      make.center.equalTo(self.view)
    }
    
    
    label.text = "No Category"
    
    notificationToken = mapper.categories.observe { [unowned self] changes in
      switch changes {
        case .initial: break
        case .update(let results, deletions: _, insertions: _, modifications: _):
          results.forEach { category in
            self.label.text = "Just added the category \(category.name)"
          }
        case .error: break
      }
    }
  }


  deinit {
    notificationToken?.invalidate()
    notificationToken = nil
  }
}

