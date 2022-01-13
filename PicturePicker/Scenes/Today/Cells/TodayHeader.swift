//
// Copyright (c) 2022  All rights reserved.
// 

import UIKit

class TodayHeader: UICollectionReusableView {

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 34, weight: .bold)
    label.textColor = .black
    label.text = "Today"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .gray
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
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

  private func setupInterface() {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "EEEE MMM d yyyy"
    dateLabel.text = dateFormater.string(from: Date())

    addSubview(titleLabel)
    addSubview(dateLabel)
  }

  private func setupConstraintes() {
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: topAnchor),
      dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
      titleLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor)
    ])
  }

}
