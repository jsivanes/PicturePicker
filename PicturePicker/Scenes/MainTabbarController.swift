//
// Copyright (c) 2022  All rights reserved.
// 

import UIKit

class MainTabbarController: UITabBarController {

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupInterface()
  }

  private func setupInterface() {
    let todayVC = TodayViewController()
    todayVC.title = "Today"
    todayVC.setup()
    let searchVC = SearchViewController()
    searchVC.title = "Search"
    searchVC.setup()
    let navVC = UINavigationController(rootViewController: searchVC)

    setViewControllers([todayVC, navVC], animated: false)

    if let items = tabBar.items, items.count == 2 {
      items[0].image = UIImage(named: "today", in: nil, with: nil)
      items[1].image = UIImage(systemName: "magnifyingglass")
    }
  }
}
