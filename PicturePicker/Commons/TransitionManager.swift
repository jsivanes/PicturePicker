//
// Copyright (c) 2022  All rights reserved.
// 

import UIKit

enum TransitionType {
  case present
  case dismiss

  var blurAlpa: CGFloat { return self == .present ? 1 : 0 }
  var next: TransitionType { return self == .present ? .dismiss : .present }
}

class TransitionManager: NSObject {

  var transitionType: TransitionType = .present
  let transitionDuration = 0.8

  lazy var blurEffectView: UIVisualEffectView = {
    let blurEffet = UIBlurEffect(style: .light)
    let visualEffectView = UIVisualEffectView(effect: blurEffet)
    return visualEffectView
  }()

  private func addBackgroundViews(to containerView: UIView) {
    blurEffectView.frame = containerView.frame
    blurEffectView.alpha = transitionType.next.blurAlpa
    containerView.addSubview(blurEffectView)
  }

  private func createPictureView(todayCell: TodayCell) -> UIView? {
    let pictureView = todayCell.snapshotView(afterScreenUpdates: false)
    let absoluteViewFrame = todayCell.photoView.convert(todayCell.photoView.frame, to: nil)
    pictureView?.frame = absoluteViewFrame
    return pictureView
  }

  private func fetchTodayCell(from viewController: UIViewController?) -> TodayCell? {
    if let tabController = viewController as? UITabBarController {
      return (tabController.selectedViewController as? TodayViewController)?.selectedCell
    }

    let navController = viewController as? UINavigationController
    let searchController = navController?.viewControllers.first(where: { ($0 as? SearchViewController) != nil }) as? SearchViewController
    return searchController?.selectedCell
  }
}

extension TransitionManager: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return transitionDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let containerView = transitionContext.containerView
    containerView.subviews.forEach({ $0.removeFromSuperview() })

    if transitionType == .present {
      addBackgroundViews(to: containerView)
    }

    let fromView = transitionContext.viewController(forKey: .from)
    let toView = transitionContext.viewController(forKey: .to)




    guard let todayCell = (transitionType == .present) ? fetchTodayCell(from: fromView) : fetchTodayCell(from: toView),
          let pictureView = createPictureView(todayCell: todayCell) else { return }


    containerView.addSubview(pictureView)
    todayCell.isHidden = true

    if transitionType == .present {
      let detailView = toView as! DetailsViewController
      containerView.addSubview(detailView.view)

      let safeAreaTop = detailView.view.safeAreaInsets.top
      let leadingInset = detailView.calculateLeadingAndTrainlingInset(for: detailView.view.frame.width)
      let detailsPictureFrame = CGRect(x: leadingInset,
                                       y: safeAreaTop,
                                       width: detailView.cellWidthSize,
                                       height: detailView.cellWidthSize)
      detailView.view.isHidden = true
      moveAndConvertTo(pictureView: pictureView, containerView: containerView, toFrame: detailsPictureFrame) {
        detailView.view.isHidden = false
        pictureView.removeFromSuperview()
        todayCell.isHidden = false
        transitionContext.completeTransition(true)
      }

    } else {
      let detailView = fromView as! DetailsViewController
      detailView.view.isHidden = true
      let safeAreaTop = detailView.view.safeAreaInsets.top
      let leadingInset = detailView.calculateLeadingAndTrainlingInset(for: detailView.view.frame.width)
      let detailsPictureFrame = CGRect(x: leadingInset,
                                       y: safeAreaTop,
                                       width: detailView.cellWidthSize,
                                       height: detailView.cellWidthSize)
      pictureView.frame = detailsPictureFrame

      let absoluteViewFrame = todayCell.photoView.convert(todayCell.photoView.frame, to: nil)
      moveAndConvertTo(pictureView: pictureView, containerView: containerView, toFrame: absoluteViewFrame) {
        todayCell.isHidden = false
        transitionContext.completeTransition(true)
      }
    }
  }

  func makeExpandContractAnimator(for pictureView: UIView, in containerView: UIView, frame: CGRect) -> UIViewPropertyAnimator {
    let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
    let animator = UIViewPropertyAnimator(duration: transitionDuration, timingParameters: springTiming)
    animator.addAnimations {
      pictureView.transform = .identity
      pictureView.frame = frame
      self.blurEffectView.alpha = self.transitionType.blurAlpa

      containerView.layoutIfNeeded()
    }
    return animator
  }

  func moveAndConvertTo(pictureView: UIView, containerView: UIView, toFrame: CGRect, completion: @escaping () -> ()) {
    let expandAnimator = makeExpandContractAnimator(for: pictureView, in: containerView, frame: toFrame)

    expandAnimator.addCompletion { _ in
      completion()
    }

    expandAnimator.startAnimation()
  }

}


extension TransitionManager: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transitionType = .present
    return self
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transitionType = .dismiss
    return self
  }
}
