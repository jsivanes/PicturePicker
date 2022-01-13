//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import UIKit

protocol DetailsDisplayLogic: AnyObject {
  func display(_ viewModel: DetailsScene.ViewModel)
  func display(_ error: String)
}

final class DetailsViewController: UIViewController {

  var router: DetailsRoutingProtocol?

  private var interactor: DetailsBusinessLogic?
  private var dataSource: UICollectionViewDiffableDataSource<Int, DetailsScene.Item>?
  private var viewModel: DetailsScene.ViewModel?

  let numberOfItem: CGFloat = 2
  let interItemSpacing: CGFloat = 8

  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "close", in: nil, with: nil), for: .normal)
    button.backgroundColor = .lightGray
    button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var collectionView: UICollectionView = {
    let collection = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    collection.register(DetailsFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DetailsFooter.self))
    collection.register(TodayCell.self, forCellWithReuseIdentifier: String(describing: TodayCell.self))
    collection.translatesAutoresizingMaskIntoConstraints = false
    return collection
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupInterface()
    setupConstraints()

    interactor?.fetch()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    closeButton.layer.cornerRadius = closeButton.bounds.width / 2
  }

  func setup() {
    let viewController = self
    let presenter = DetailsPresenter(display: viewController)
    let interactor = DetailsInteractor(presenter: presenter)
    let router = DetailsRouter(viewController: viewController, dataStore: interactor)
    viewController.interactor = interactor
    viewController.router = router
  }

  func cellWidthSize(for availableWidth: CGFloat) -> CGFloat {
    (availableWidth / numberOfItem) - interItemSpacing
  }

  func leadingAndTrainlingInset(for availableWidth: CGFloat) -> CGFloat {
    let remainingWidth = availableWidth - cellWidthSize(for: availableWidth) * numberOfItem
    return max(2, (remainingWidth / 2.0) - interItemSpacing)
  }

  private func setupInterface() {
    view.backgroundColor = .white
    view.addSubview(collectionView)
    view.addSubview(closeButton)

    configureDataSource()
  }

  private func setupConstraints() {
    collectionView.pinToSuperView()
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      closeButton.widthAnchor.constraint(equalToConstant: 36),
      closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor, multiplier: 1.0),
      closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }

  @objc private func didTapCloseButton() {
    dismiss(animated: true, completion: nil)
  }
}

extension DetailsViewController: DetailsDisplayLogic {

  func display(_ viewModel: DetailsScene.ViewModel) {
    self.viewModel = viewModel
    var snapshot = NSDiffableDataSourceSnapshot<Int, DetailsScene.Item>()
    snapshot.appendSections([0])
    snapshot.appendItems(viewModel.items, toSection: 0)
    dataSource?.apply(snapshot)
  }

  func display(_ error: String) {
    let alertView = UIAlertController(title: "Information", message: error, preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
    present(alertView, animated: true, completion: nil)
  }
}


extension DetailsViewController {
  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] section, layoutEnvironment in
      guard let self = self else { return nil }
      let availableWith = layoutEnvironment.container.contentSize.width
      let cellWidthSize = self.cellWidthSize(for: availableWith)
      let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cellWidthSize),
                                            heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .absolute(cellWidthSize))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.interItemSpacing = .fixed(self.interItemSpacing)
      let leadingAndTrailingInset = self.leadingAndTrainlingInset(for: availableWith)
      group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: leadingAndTrailingInset, bottom: 0, trailing: leadingAndTrailingInset)

      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 8

      let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
      let footerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
      footerElement.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
      section.boundarySupplementaryItems = [footerElement]

      return section
    }
  }

  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Int, DetailsScene.Item>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, item: DetailsScene.Item) -> UICollectionViewCell? in
      let identifier = String(describing: TodayCell.self)
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TodayCell else { return nil }

      cell.setup(item.picture, pictureImage: item.pictureImage)
      return cell
    }

    dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
      guard kind == UICollectionView.elementKindSectionFooter,
            let model = self?.viewModel else { return nil }
      let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: DetailsFooter.self), for: indexPath) as? DetailsFooter
      footer?.setup(views: model.views, downloads: model.downloads)
      return footer
    }
  }
}
