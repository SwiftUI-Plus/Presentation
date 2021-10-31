#if os(iOS)

import SwiftUI
import SafariServices

struct Presenter<Content: View>: UIViewRepresentable {

    @Binding var presentation: Presentation
    var shouldDismiss: (() -> Bool)? = nil
    var onDismissAttempt: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil
    var content: () -> Content

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        return context.coordinator.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.parent = self
    }

    func disableInteractiveDismiss(_ handler: @escaping () -> Bool) -> Presenter<Content> {
        var view = self
        view.shouldDismiss = handler
        return view
    }

    func onDismissAttempt(_ handler: @escaping () -> Void) -> Presenter<Content> {
        var view = self
        view.onDismissAttempt = handler
        return view
    }
}

extension Presenter {

    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {

        var parent: Presenter {
            didSet {
                updateControllerLifecycle(
                    from: oldValue.presentation,
                    to: parent.presentation
                )
            }
        }

        init(parent: Presenter) {
            self.parent = parent
        }

        let view = UIView()
        private weak var controller: UIHostingController<AnyView>?

        private func updateControllerLifecycle(from oldValue: Presentation, to newValue: Presentation) {
            switch (oldValue.isPresented, newValue.isPresented) {
            case (false, true):
                presentController()
            case (true, false):
                dismissController()
            case (true, true):
                updateController()
            case (false, false):
                break
            }
        }

        // MARK: Presentation Handlers

        private func presentController() {
            let rootView = parent.content()
            let controller = UIHostingController(
                rootView: AnyView(
                    rootView
                        .environment(\.presentation, parent._presentation)
                )
            )

            controller.view.backgroundColor = .clear
//            controller.isModalInPresentation = parent.presentation.isModalInPresentation
            controller.modalTransitionStyle = parent.presentation.transitionStyle
            controller.modalPresentationStyle = parent.presentation.presentationStyle
            controller.presentationController?.delegate = self
            controller.popoverPresentationController?.sourceRect = view.bounds
            controller.popoverPresentationController?.sourceView = view

            guard let presenting = view.owningController else {
                resetItemBinding()
                return
            }

            presenting.present(controller, animated: true)
            self.controller = controller
        }

        private func updateController() {
            guard let controller = controller else {
                return
            }

            let rootView = parent.content()
            controller.rootView = AnyView(
                rootView
                    .environment(\.presentation, parent._presentation)
            )
        }

        private func dismissController() {
            guard let controller = controller else {
                return
            }

            controller.presentingViewController?.dismiss(animated: true)
            self.handleDismissal()
        }

        private func resetItemBinding() {
            parent.presentation.dismiss()
        }

        private func handleDismissal() {
            parent.onDismiss?()
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            resetItemBinding()
            parent.onDismiss?()
        }

        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            parent.shouldDismiss?() ?? !parent.presentation.isModalInPresentation
        }

        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            parent.onDismissAttempt?()
        }

    }
}

#endif
