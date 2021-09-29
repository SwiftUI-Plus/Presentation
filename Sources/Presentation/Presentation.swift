import SwiftUI

public struct Presentation {

    var _isPresented: Binding<Bool>

    public var isModalInPresentation: Bool
    public var transitionStyle: UIModalTransitionStyle
    public var presentationStyle: UIModalPresentationStyle

    /// Indicates whether a view is currently presented.
    public var isPresented: Bool {
        _isPresented.wrappedValue
    }

    /// Dismisses the current view. If the current view is not being presented, this function is a no-op
    public mutating func dismiss() {
        _isPresented.wrappedValue = false
    }

}

public struct PresentationEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Binding<Presentation> =
        .constant(
            Presentation(
                _isPresented: .constant(false),
                isModalInPresentation: false,
                transitionStyle: .coverVertical,
                presentationStyle: .pageSheet
            )
        )
}

extension EnvironmentValues {
    public var presentation: Binding<Presentation> {
        get { self[PresentationEnvironmentKey.self] }
        set { self[PresentationEnvironmentKey.self] = newValue }
    }
}
