import SwiftUI

#if os(iOS)

public extension View {

    /// Behaves similarly to `sheet` and `fullScreenCover` but if works on iOS 13+.
    /// You _must_ use `.presentation` __not__ `presentationMode` when dismissing this view
    ///
    ///     @Environment(\.presentation) private var presentation
    ///     ...
    ///     presentation.wrappedValue.dismiss()
    func present<Content>(
        isPresented: Binding<Bool>,
        transition: UIModalTransitionStyle = .coverVertical,
        style: UIModalPresentationStyle,
        @ViewBuilder _ content: @escaping () -> Content,
        shouldDismiss: (() -> Bool)? = nil,
        onDismissAttempt: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View where Content: View {
        let binding = Binding(
            get: {
                Presentation(
                    _isPresented: isPresented,
                    isModalInPresentation: true,
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
            .disableInteractiveDismiss({ shouldDismiss?() ?? true })
            .onDismissAttempt({ onDismissAttempt?() })
        )
    }

    /// Behaves similarly to `sheet` and `fullScreenCover` but if works on iOS 13+.
    /// You _must_ use `.presentation` __not__ `presentationMode` when dismissing this view
    ///
    ///     @Environment(\.presentation) private var presentation
    ///     ...
    ///     presentation.wrappedValue.dismiss()
    func present<Item, Content>(
        item: Binding<Item?>,
        transition: UIModalTransitionStyle = .coverVertical,
        style: UIModalPresentationStyle,
        @ViewBuilder _ content: @escaping (Item) -> Content,
        shouldDismiss: (() -> Bool)? = nil,
        onDismissAttempt: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View where Item: Identifiable, Content: View {
        let boolBinding = Binding(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        let binding = Binding(
            get: {
                Presentation(
                    _isPresented: boolBinding,
                    isModalInPresentation: true,
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
            .disableInteractiveDismiss({ shouldDismiss?() ?? true })
            .onDismissAttempt({ onDismissAttempt?() })
        )
    }

}

#endif
