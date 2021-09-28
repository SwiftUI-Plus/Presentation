import SwiftUI

#if os(iOS)

public extension UIViewController {

    /// Presents a SwiftUI view from this controller
    func present<V: View>(@ViewBuilder _ rootView: () -> V, onDismiss: (() -> Void)? = nil) {
        present(rootView: rootView(), onDismiss: onDismiss)
    }

    /// Presents a SwiftUI view from this controller
    func present<V: View>(rootView: V, onDismiss: (() -> Void)? = nil) {
        let controller = viewController(rootView: rootView, onDismiss: onDismiss)
        present(controller, animated: true)
    }

    internal func viewController<V: View>(rootView: V, isModal: Bool = false, transition: UIModalTransitionStyle = .coverVertical, style: UIModalPresentationStyle = .pageSheet, onDismiss: (() -> Void)?) -> UIViewController {
        var delegate: PresentationDelegate?

        let presentation = Binding<Presentation> {
            Presentation(.constant(false))
        } set: { _ in
            onDismiss?()
            self.dismiss(animated: true) {
                /*
                 This serves 2 purposes:
                 1. By referencing in this closure,
                    we retain it for the lifecycle of the presentation
                 2. When we dismiss, we need to nil it to ensure we release it
                 */
                delegate = nil
            }
        }

        let controller = UIHostingController(
            rootView: rootView.environment(\.presentation, presentation)
        )

        controller.isModalInPresentation = isModal
        controller.modalTransitionStyle = transition
        controller.view.backgroundColor = .clear

        delegate = PresentationDelegate()
        delegate?.style = style
        delegate?.handler = {
            // update the state for an interactive dismiss
            presentation.wrappedValue.dismiss()
        }

        controller.presentationController?.delegate = delegate
        return controller
    }
}

private final class PresentationDelegate: NSObject, UIAdaptivePresentationControllerDelegate, UIViewControllerTransitioningDelegate {
    var style: UIModalPresentationStyle = .pageSheet
    var handler: (() -> Void)?
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle { style }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) { handler?() }
}

#endif
