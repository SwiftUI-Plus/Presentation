import SwiftUI

#if os(iOS)

public extension View {

    /// Behaves similarly to `fullScreenCover` but if works on iOS 13+.
    /// You _must_ use `.presentation` __not__ `presentationMode` when dismissing this view
    ///
    ///     @Environment(\.presentation) private var presentation
    ///     ...
    ///     presentation.wrappedValue.dismiss()
    func present<Content>(
        isPresented: Binding<Bool>,
        isModal: Bool = false,
        transition: UIModalTransitionStyle = .coverVertical,
        style: UIModalPresentationStyle,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        let binding = Binding(
            get: {
                Presentation(
                    _isPresented: isPresented,
                    isModalInPresentation: isModal,
                    transitionStyle: transition,
                    presentationStyle: style
                )
            },
            set: {
                if !$0.isPresented {
                    isPresented.wrappedValue = false
                }
            }
        )

        return background(
            Presenter(
                presentation: binding,
                onDismiss: onDismiss,
                content: content
            )
        )
    }

    /// Behaves similarly to `fullScreenCover` but if works on iOS 13+.
    /// You _must_ use `.presentation` __not__ `presentationMode` when dismissing this view
    ///
    ///     @Environment(\.presentation) private var presentation
    ///     ...
    ///     presentation.wrappedValue.dismiss()
    func present<Item, Content>(
        item: Binding<Item?>,
        isModal: Bool = false,
        transition: UIModalTransitionStyle = .coverVertical,
        style: UIModalPresentationStyle,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View where Item: Identifiable, Content: View {
        let boolBinding = Binding(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        let binding = Binding(
            get: {
                Presentation(
                    _isPresented: boolBinding,
                    isModalInPresentation: isModal,
                    transitionStyle: transition,
                    presentationStyle: style
                )
            },
            set: {
                if !$0.isPresented {
                    boolBinding.wrappedValue = false
                }
            }
        )

        return background(
            Presenter(
                presentation: binding,
                onDismiss: onDismiss,
                content: { content(item.wrappedValue!) }
            )
        )
    }

}

#endif
