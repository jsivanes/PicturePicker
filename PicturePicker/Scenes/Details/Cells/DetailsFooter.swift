//
// Copyright (c) 2022  All rights reserved.
// 

import UIKit

class DetailsFooter: UICollectionReusableView {

  private lazy var viewsLogo: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "views", in: nil, with: nil)
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()

  private lazy var downloadsLogo: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "download", in: nil, with: nil)
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .regular)
    label.text = "Picture Statistics"
    label.textColor = .gray
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var viewsLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.textColor = .gray
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var downloadsLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.textColor = .gray
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var verticalStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 8
    return stack
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupInterface()
    setupConstraintes()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupInterface()
    setupConstraintes()
  }

  func setup(views: Int, downloads: Int) {
    downloadsLabel.text = "\(downloads) downloads"
    viewsLabel.text = "\(views) views"
  }

  private func setupInterface() {
    verticalStackView.addArrangedSubview(titleLabel)
    let viewsStack = makeHorizontalStackView()
    viewsStack.addArrangedSubview(viewsLogo)
    viewsStack.addArrangedSubview(viewsLabel)
    verticalStackView.addArrangedSubview(viewsStack)
    let downloadStack = makeHorizontalStackView()
    downloadStack.addArrangedSubview(downloadsLogo)
    downloadStack.addArrangedSubview(downloadsLabel)
    verticalStackView.addArrangedSubview(downloadStack)
    addSubview(verticalStackView)
  }

  private func setupConstraintes() {
    verticalStackView.pinToSuperView(top: 16)
    NSLayoutConstraint.activate([
      viewsLogo.widthAnchor.constraint(equalToConstant: 24),
      viewsLogo.heightAnchor.constraint(equalTo: viewsLogo.widthAnchor, multiplier: 1.0),
      downloadsLogo.widthAnchor.constraint(equalTo: viewsLogo.widthAnchor),
      downloadsLogo.heightAnchor.constraint(equalTo: downloadsLogo.widthAnchor, multiplier: 1.0)
    ])
  }

  private func makeHorizontalStackView() -> UIStackView {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.distribution = .fillProportionally
    stack.spacing = 8
    return stack
  }
}
