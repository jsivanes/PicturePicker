//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import UIKit

protocol TodayRoutingLogic {
  func routeTo(details: String, picture: UIImage?)
}

protocol TodayDataPassing {
  var dataStore: TodayDataStore { get set }
}

typealias TodayRoutingProtocol = TodayRoutingLogic & TodayDataPassing

final class TodayRouter: TodayRoutingProtocol {

  var dataStore: TodayDataStore
  private weak var viewController: TodayViewController?
  private let transitionManager = TransitionManager()

  init(viewController: TodayViewController, dataStore: TodayDataStore) {
    self.viewController = viewController
    self.dataStore = dataStore
  }

  func routeTo(details: String, picture: UIImage?) {
    let detailsVC = DetailsViewController()
    detailsVC.setup()
    detailsVC.router?.dataStore.link = details
    detailsVC.router?.dataStore.selectedPicture = picture
    detailsVC.modalPresentationStyle = .overCurrentContext
    detailsVC.transitioningDelegate = transitionManager
    viewController?.present(detailsVC, animated: true, completion: nil)
  }
}
