import SwiftUI

public struct Presentation {

    private var _isPresented: Binding<Bool>

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

    public init(_ isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }

}

public struct PresentationEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Binding<Presentation> =
        .constant(Presentation(.constant(false)))
}

extension EnvironmentValues {
    public var presentation: Binding<Presentation> {
        get { self[PresentationEnvironmentKey.self] }
        set { self[PresentationEnvironmentKey.self] = newValue }
    }
}
