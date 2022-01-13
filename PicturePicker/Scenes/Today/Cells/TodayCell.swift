//
// Copyright (c) 2022  All rights reserved.
// 

import UIKit

class TodayCell: UICollectionViewCell {

  lazy var photoView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private lazy var desciptionlabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var userPicture: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.layer.borderColor = UIColor.white.cgColor
    imageView.layer.borderWidth = 3
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .bold)
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var likesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .bold)
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupInterface()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupInterface()
    setupConstraints()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    userPicture.layer.cornerRadius = userPicture.bounds.width / 2
  }

  func setup(_ photo: Picture) {
    if let picture = photo.picture {
      photoView.load(str: picture)
    }
    desciptionlabel.text = photo.description
    usernameLabel.text = photo.userName
    if let picture = photo.userPicture {
      userPicture.load(str: picture)
    }
    likesLabel.text = "\(photo.likes) likes"
  }

  func setup(_ picture: String?, pictureImage: UIImage?) {
    if let image = pictureImage {
      photoView.image = image
    } else if let picture = picture {
      photoView.load(str: picture)
    }
    desciptionlabel.isHidden = true
    userPicture.isHidden = true
    usernameLabel.isHidden = true
    likesLabel.isHidden = true
  }

  private func setupInterface() {
    contentView.backgroundColor = .lightGray

    contentView.layer.cornerRadius = 8
    photoView.layer.cornerRadius = 8
    contentView.addSubview(photoView)
    contentView.addSubview(desciptionlabel)
    contentView.addSubview(userPicture)
    contentView.addSubview(usernameLabel)
    contentView.addSubview(likesLabel)

    updateShadow()
  }

  private func setupConstraints() {
    photoView.pinToSuperView()
    NSLayoutConstraint.activate([
      desciptionlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      desciptionlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      desciptionlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      userPicture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
      userPicture.leadingAnchor.constraint(equalTo: desciptionlabel.leadingAnchor),
      userPicture.widthAnchor.constraint(equalToConstant: 56),
      userPicture.heightAnchor.constraint(equalTo: userPicture.widthAnchor, multiplier: 1.0),
      usernameLabel.leadingAnchor.constraint(equalTo: userPicture.trailingAnchor, constant: 8),
      usernameLabel.topAnchor.constraint(equalTo: userPicture.centerYAnchor, constant: -8),
      usernameLabel.trailingAnchor.constraint(equalTo: desciptionlabel.trailingAnchor),
      likesLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
      likesLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
      likesLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 6)
    ])
  }

  private func updateShadow() {
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
    contentView.layer.shadowRadius = 8
    contentView.layer.shadowOpacity = 0.3
    contentView.layer.masksToBounds = false
    let rect = CGRect(origin: .zero, size: contentView.frame.size)
    contentView.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 16).cgPath
    contentView.layer.shouldRasterize = true
    contentView.layer.rasterizationScale = UIScreen.main.scale
  }
}
