import SwiftUI

public struct Presentation {

    var _isPresented: Binding<Bool>

    #if os(iOS)
    public var isModalInPresentation: Bool
    public var transitionStyle: UIModalTransitionStyle
    public var presentationStyle: UIModalPresentationStyle
    #endif

    /// Indicates whether a view is currently presented.
    public var isPresented: Bool {
        _isPresented.wrappedValue
    }

    /// Dismisses the view if it is currently presented.
    ///
    /// If `isPresented` is false, `dismiss()` is a no-op.
    public mutating func dismiss() {
        _isPresented.wrappedValue = false
    }

}

public struct PresentationEnvironmentKey: EnvironmentKey {
#if os(iOS)
    public static let defaultValue: Binding<Presentation> =
        .constant(
            Presentation(
                _isPresented: .constant(false),
                isModalInPresentation: false,
                transitionStyle: .coverVertical,
                presentationStyle: .pageSheet
            )
        )
#else
    public static let defaultValue: Binding<Presentation> =
        .constant(
            Presentation(
                _isPresented: .constant(false)
            )
        )
#endif
}

extension EnvironmentValues {
    public var presentation: Binding<Presentation> {
        get { self[PresentationEnvironmentKey.self] }
        set { self[PresentationEnvironmentKey.self] = newValue }
    }
}
