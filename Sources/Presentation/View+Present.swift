import SwiftUI

public extension View {

    /// Behaves similarly to `sheet` however this will always `dismiss` a sheet and never `pop` a navigation stack
    ///
    ///     @Environment(\.presentation) private var presentation
    ///     ...
    ///     presentation.wrappedValue.dismiss()
    ///
    /// - Note: `isModal` is currently ignored in macOS
    func present<Content>(
        isPresented: Binding<Bool>,
        isModal: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        let binding = Binding(
            get: {
                Presentation(
                    _isPresented: isPresented,
                    isModalInPresentation: isModal,
                    transitionStyle: .coverVertical,
                    presentationStyle: .pageSheet
                )
            },
            set: {
                if !$0.isPresented {
                    isPresented.wrappedValue = false
                }
            }
        )

        return sheet(isPresented: isPresented, onDismiss: onDismiss) {
            content()
                .environment(\.presentation, binding)
                #if os(iOS)
                .modalInPresentation(isModal)
                #endif
        }
    }

    /// Behaves similarly to `sheet` however this will always `dismiss` a sheet and never `pop` a navigation stack.
    ///
    ///     @Environment(\.presentation) private var presentation
    ///     ...
    ///     presentation.wrappedValue.dismiss()
    ///
    /// - Note: `isModal` is currently ignored in macOS
    func present<Item, Content>(
        item: Binding<Item?>,
        isModal: Bool = false,
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
                    transitionStyle: .coverVertical,
                    presentationStyle: .pageSheet
                )
            },
            set: {
                if !$0.isPresented {
                    boolBinding.wrappedValue = false
                }
            }
        )

        return sheet(item: item, onDismiss: onDismiss) { item in
            content(item)
                .environment(\.presentation, binding)
                #if os(iOS)
                .modalInPresentation(isModal)
                #endif
        }
    }

}
