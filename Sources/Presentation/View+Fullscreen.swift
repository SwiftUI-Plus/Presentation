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
        background(FullscreenView(isPresented: isPresented, isModal: isModal, transition: transition, style: style, onDismiss: onDismiss, content: content))
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
        let binding = Binding(
            get: { item.wrappedValue != nil },
            set: { value, _ in
                if !value { item.wrappedValue = nil }
            }
        )

        return background(FullscreenView(isPresented: binding, isModal: isModal, transition: transition, style: style, onDismiss: onDismiss, content: {
            content(item.wrappedValue!)
        }))
    }

}

#endif
