//
//  PushAnimator.swift
//  GitHubContributorsList
//
//  Created by Viacheslav Embaturov on 18.05.2021.
//

import UIKit

protocol TransitionViewProtocol: AnyObject {
    var avatarImageView: UIImageView! { get }
}

class AvatarTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval
    weak var fromView: TransitionViewProtocol?
    weak var toView: TransitionViewProtocol?

    init(duration: TimeInterval, fromView: TransitionViewProtocol, toView: TransitionViewProtocol) {
        self.duration = duration
        self.fromView = fromView
        self.toView = toView
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let from = fromView,
              let to = toView,
              let fromVCView = transitionContext.view(forKey: .from),
              let toVCView = transitionContext.view(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView

        let avatarImageViewCopy = UIImageView(image: from.avatarImageView.image)
        avatarImageViewCopy.contentMode = .scaleAspectFit
        avatarImageViewCopy.clipsToBounds = true

        avatarImageViewCopy.frame = from.avatarImageView.convert(from.avatarImageView.bounds, to: containerView)

        containerView.addSubview(toVCView)
        containerView.addSubview(fromVCView)
        containerView.addSubview(avatarImageViewCopy)
        from.avatarImageView.isHidden = true
        to.avatarImageView.isHidden = true

        toVCView.setNeedsLayout()
        toVCView.layoutIfNeeded()
        let resultFrame = to.avatarImageView.convert(to.avatarImageView.bounds, to: containerView)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            fromVCView.alpha = 0
            avatarImageViewCopy.frame = resultFrame
        }) { _ in
            from.avatarImageView.isHidden = false
            to.avatarImageView.isHidden = false
            avatarImageViewCopy.removeFromSuperview()
            transitionContext.completeTransition(true)
            fromVCView.alpha = 1
        }
    }
}
