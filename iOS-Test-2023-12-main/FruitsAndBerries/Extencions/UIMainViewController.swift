import UIKit

class UIMainViewController: UIViewController {
    private var swipeToDismissTransitioningDelegate: UIViewControllerTransitioningDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeToDismiss()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemPink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    private func setupSwipeToDismiss() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            view.addGestureRecognizer(panGesture)
            swipeToDismissTransitioningDelegate = SwipeToDismissTransitioningDelegate()
            transitioningDelegate = swipeToDismissTransitioningDelegate
            modalPresentationStyle = .custom
        
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard translation.x > 0 else {
            if gesture.state == .ended || gesture.state == .cancelled {
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
            return
        }
        
        let progress = min(max(translation.x / 200, 0), 1)
        
        switch gesture.state {
        case .changed:
            view.transform = CGAffineTransform(translationX: translation.x, y: 0)
        case .ended, .cancelled:
            if progress > 0.5 {
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        default:
            break
        }
    }
    
}
final class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

final class SwipeToDismissTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeDismissAnimator()
    }
}

final class SwipeDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if !transitionContext.transitionWasCancelled {
                fromVC.view.transform = .identity
            }
        }
    }
}

extension UIViewController {
    func presentCustomDismissible(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        let transitioningDelegate = SwipeToDismissTransitioningDelegate()
        let controllerToPresent: UIViewController
        if let navController = viewControllerToPresent as? UINavigationController {
            controllerToPresent = navController
        } else {
            controllerToPresent = UINavigationController(rootViewController: viewControllerToPresent)
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            controllerToPresent.modalPresentationStyle = .custom
            controllerToPresent.transitioningDelegate = transitioningDelegate
            present(controllerToPresent, animated: flag, completion: completion)
        }
        objc_setAssociatedObject(controllerToPresent, &AssociatedKeys.transitioningDelegate, transitioningDelegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


private struct AssociatedKeys {
    static var transitioningDelegate: UInt8 = 0
}
