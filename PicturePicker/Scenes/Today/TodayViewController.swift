//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import UIKit

protocol TodayDisplayLogic: AnyObject {
  func display(_ viewModel: TodayScene.ViewModel)
  func display(_ error: String)
}

final class TodayViewController: UIViewController {

  var router: TodayRoutingProtocol?
  var interactor: TodayBusinessLogic?

  var selectedCell: TodayCell?

  private lazy var collectionView: UICollectionView = {
    CollectionViewFactory.makeCollectionView(header: true, delegate: self)
  }()

  private var dataSource: UICollectionViewDiffableDataSource<Int, Picture>?

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupInterface()
    setupConstraints()
    interactor?.fetch()
  }

  func setup() {
    let viewController = self
    let presenter = TodayPresenter(display: viewController)
    let interactor = TodayInteractor(presenter: presenter)
    let router = TodayRouter(viewController: viewController, dataStore: interactor)
    viewController.interactor = interactor
    viewController.router = router
  }

  private func setupInterface() {
    view.backgroundColor = .white
    view.addSubview(collectionView)

    dataSource = CollectionViewFactory.makeDataSource(collectionView: collectionView)
  }

  private func setupConstraints() {
    collectionView.pinToSuperView()
  }

}

extension TodayViewController: TodayDisplayLogic {

  func display(_ viewModel: TodayScene.ViewModel) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Picture>()
    snapshot.appendSections([0])
    snapshot.appendItems(viewModel.picture, toSection: 0)
    dataSource?.apply(snapshot)
  }

  func display(_ error: String) {
    let alertView = UIAlertController(title: "Information", message: error, preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
    present(alertView, animated: true, completion: nil)
  }
}

extension TodayViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource?.itemIdentifier(for: indexPath),
    let cell = collectionView.cellForItem(at: indexPath) as? TodayCell else { return }
    selectedCell = cell
    router?.routeTo(details: item.detailLinks, picture: cell.photoView.image)
  }
}
