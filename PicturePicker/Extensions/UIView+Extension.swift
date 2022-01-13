//
// Copyright (c) 2022  All rights reserved.
// 

import UIKit

extension UIView {

  public func pinToSuperView(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
    guard let superview = superview else { return }
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom),
      leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing)
    ])
  }
}
