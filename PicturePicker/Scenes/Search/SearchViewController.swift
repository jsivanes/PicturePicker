//
//  Copyright (c) 2022  All rights reserved.
//

import UIKit
import Combine

protocol SearchDisplayLogic: AnyObject {
  func display(_ viewModel: SearchScene.ViewModel)
  func display(_ error: String)
}

final class SearchViewController: UIViewController {

  var router: SearchRoutingProtocol?
  var selectedCell: TodayCell?
  var searchPublisher: AnyCancellable?

  private lazy var searchController: UISearchController = {
    let search = UISearchController()
    return search
  }()

  private lazy var collectionView: UICollectionView = {
    CollectionViewFactory.makeCollectionView(header: false, delegate: self)
  }()

  private var interactor: SearchBusinessLogic?
  private var dataSource: UICollectionViewDiffableDataSource<Int, Picture>?

  func setup() {
    let viewController = self
    let presenter = SearchPresenter(display: viewController)
    let interactor = SearchInteractor(presenter: presenter)
    let router = SearchRouter(viewController: viewController, dataStore: interactor)
    viewController.interactor = interactor
    viewController.router = router
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupInterface()
    setupConstraints()
  }

  private func setupInterface() {
    view.backgroundColor = .white
    view.addSubview(collectionView)
    navigationItem.searchController = searchController

    dataSource = CollectionViewFactory.makeDataSource(collectionView: collectionView)
    registerSearchBarListener()
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func registerSearchBarListener() {
    let notification = UISearchTextField.textDidChangeNotification
    let observableObject = searchController.searchBar.searchTextField

    searchPublisher = NotificationCenter.default.publisher(for: notification, object: observableObject)
      .map({ (notification) -> String? in
        guard let searchField = notification.object as? UISearchTextField else { return nil }
        return searchField.text
      })
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] searchText in
        guard let self = self,
              let text = searchText,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        self.interactor?.fetch(text)
      }
  }
}

extension SearchViewController: SearchDisplayLogic {

  func display(_ viewModel: SearchScene.ViewModel) {
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

extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource?.itemIdentifier(for: indexPath),
          let cell = collectionView.cellForItem(at: indexPath) as? TodayCell else { return }
    selectedCell = cell
    router?.routeTo(details: item.detailLinks, picture: cell.photoView.image)
  }
}
