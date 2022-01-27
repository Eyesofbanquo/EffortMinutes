//
//  RankDetailViewController.swift
//  EffortMinutes
//
//  Created by Markim Shaw on 1/17/22.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit

final class RankDetailViewController: UIViewController {
  
  private var rank: Rank
  
  init(rank: Rank) {
    self.rank = rank
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let hostingController = UIHostingController(rootView: RankDetailView(rank: rank))
    self.addChild(hostingController)
    self.view.addSubview(hostingController.view)
    hostingController.view.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalTo(self.view)
    }
    hostingController.didMove(toParent: self)
  }
}

fileprivate struct RankDetailView: View {
  
  let rank: Rank
  
  var body: some View {
    ZStack {
      Color(uiColor: UIColor(hexString: "#CCDBDC"))
        .ignoresSafeArea()
      
      VStack {
        Text(rank.displayName)
          .font(.title)
          .bold()
          .frame(maxWidth: .infinity)
          .padding([.top, .bottom])
          .background(Color(uiColor: UIColor(hexString: "#8E6C88")))
          
          .ignoresSafeArea()
        ScrollView {
          VStack {
            Text("Effort Minutes Range")
              .font(.headline)
              .bold()
            Text(rank.subtitle)
              .font(.subheadline)
              .italic()
          }
          .foregroundColor(Color.black)
          
          Spacer()
          Text("Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text.Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text. Here is some stock text.  ")
            .foregroundColor(.black)
            .padding()
        }
        
        Spacer()
      }
      .foregroundColor(Color.white)
    }
  }
}

extension RankDetailView: PreviewProvider {
  static var previews: some View {
    RankDetailView(rank: .warlord)
  }
}
