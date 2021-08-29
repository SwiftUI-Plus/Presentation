import SwiftUI

public extension View {

    /// Behaves similarly to `sheet` however this will always `dismiss` a sheet and never `pop` a navigation stack
    ///
    ///     @Environment(\.presentation) private var presentation
    ///     ...
    ///     presentation.wrappedValue.dismiss()
    func present<Content>(
        isPresented: Binding<Bool>,
        isModal: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        let binding = Binding<Presentation>(
            get: { Presentation(isPresented) },
            set: { _, _ in }
        )

        return sheet(isPresented: isPresented, onDismiss: onDismiss) {
            content()
                .environment(\.presentation, binding)
                .modalInPresentation(isModal)
        }
    }

    /// Behaves similarly to `sheet` however this will always `dismiss` a sheet and never `pop` a navigation stack
    ///
    ///     @Environment(\.presentation) private var presentation
    ///     ...
    ///     presentation.wrappedValue.dismiss()
    func present<Item, Content>(
        item: Binding<Item?>,
        isModal: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View where Item: Identifiable, Content: View {
        let binding = Binding<Presentation>(
            get: { Presentation(.constant(item.wrappedValue != nil)) },
            set: { _, _ in item.wrappedValue = nil }
        )

        return sheet(item: item, onDismiss: onDismiss) { item in
            content(item)
                .environment(\.presentation, binding)
                .modalInPresentation(isModal)
        }
    }

}
