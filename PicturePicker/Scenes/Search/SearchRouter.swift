//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import UIKit

protocol SearchRoutingLogic {
  func routeTo(details: String, picture: UIImage?)
}

protocol SearchDataPassing {
  var dataStore: SearchDataStore { get set }
}

typealias SearchRoutingProtocol = SearchRoutingLogic & SearchDataPassing

final class SearchRouter: SearchRoutingProtocol {

  var dataStore: SearchDataStore
  private weak var viewController: SearchViewController?
  private let transitionManager = TransitionManager()


  init(viewController: SearchViewController, dataStore: SearchDataStore) {
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
    viewController?.navigationController?.present(detailsVC, animated: true, completion: nil)
  }
}
