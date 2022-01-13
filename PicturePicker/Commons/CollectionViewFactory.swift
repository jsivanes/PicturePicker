///
// Copyright (c) 2022  All rights reserved.
// 

import UIKit

enum CollectionViewFactory {
  static func makeCollectionView(header: Bool, delegate: UICollectionViewDelegate) -> UICollectionView {
    let collection = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout(header: header))
    if header {
      collection.register(TodayHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: TodayHeader.self))
    }
    collection.register(TodayCell.self, forCellWithReuseIdentifier: String(describing: TodayCell.self))
    collection.delegate = delegate
    collection.translatesAutoresizingMaskIntoConstraints = false
    return collection
  }

  static func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, Picture> {
    let dataSource = UICollectionViewDiffableDataSource<Int, Picture>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, item: Picture) -> UICollectionViewCell? in
      let identifier = String(describing: TodayCell.self)
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TodayCell else { return nil }

      cell.setup(item)
      return cell
    }

    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in

      guard kind == UICollectionView.elementKindSectionHeader else { return nil }
      return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: TodayHeader.self), for: indexPath)
    }
    return dataSource
  }

  static private func createCompositionalLayout(header: Bool) -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { section, layoutEnvironment in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
      let groupWidth = availableLayoutWidth * 0.9
      let remainingWidth = availableLayoutWidth - groupWidth
      let leadingAndTrailingInset = remainingWidth / 2.0
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: leadingAndTrailingInset, bottom: 0, trailing: leadingAndTrailingInset)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalWidth(1.0))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 16

      if header {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        headerElement.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: leadingAndTrailingInset, bottom: 0, trailing: leadingAndTrailingInset)
        section.boundarySupplementaryItems = [headerElement]
      }

      return section
    }
  }
}
