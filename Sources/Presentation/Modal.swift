import SwiftUI
import Combine

#if os(iOS)

extension View {

    /// Apply this modifier to customize the presentation
    /// - Parameters:
    ///   - isModal: If true, disables pull-to-dismiss
    ///   - style: Set the style of this presentation, useful for forcing fullscreen
    public func modalInPresentation(_ isModal: Bool = true) -> some View {
        background(PresentationView(isModal: isModal))
    }

}

private struct PresentationView: UIViewControllerRepresentable {
    let isModal: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<PresentationView>) -> UIViewController {
        Controller(isModal: isModal)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

private extension PresentationView {

    final class Controller: UIViewController {

        private let isModal: Bool

        init(isModal: Bool) {
            self.isModal = isModal
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            parent?.isModalInPresentation = isModal
        }

    }

}

#endif
