![ios](https://img.shields.io/badge/iOS-13-green)

----

> An improved backport is now available as a set of `.backport.presentation` modifiers, in a single Backports library, with a LOT more additions. This should simply my efforts and allow me and others to contribute more backports in the near future.
> [SwiftUI Backports](https://github.com/shaps80/SwiftUIBackports)

----

# Presentation

> Also available as a part of my [SwiftUI+ Collection](https://benkau.com/packages.json) – just add it to Xcode 13+

Provides a custom presentation modifier that provides more options including full screen presentations.

## Features

Presentation allows the configuration of the following properties:

-   UIModalTransitionStyle
-   UIModalPresentationStyle
-   isModalInPresentation
-   Easy API for presenting SwiftUI from UIKit

## Example

Sheet replacement in SwiftUI with a custom environment value:

```swift
struct Presenting: View {
    @State private var presentSheet: Bool = false
    @State private var presentFullscreen: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Button {
                presentSheet = true
            } label: {
                Text("Present Modal")
            }
            .present(isPresented: $present) { Presented() }

            Button {
                presentFullscreen = true
            } label: {
                Text("Present Fullscreen")
            }
            .present(isPresented: $present, style: .fullscreen) { Presented() }
        }
    }
}

struct Presented: View {
    @Environment(\.presentation) private var presentation // note this is __not__ `presentationMode`
    var body: some View {
        Button {
            presentation.wrappedValue.dismiss() // but it has an identical API
        } label: {
            Text("Dismiss")
        }
    }
}
```

Present from UIKit with a convenient and familiar API:

```swift
controller.present(Presented())
```

## Installation

The code is packaged as a framework. You can install manually (by copying the files in the `Sources` directory) or using Swift Package Manager (**preferred**)

To install using Swift Package Manager, add this to the `dependencies` section of your `Package.swift` file:

`.package(url: "https://github.com/SwiftUI-Plus/Presentation.git", .upToNextMinor(from: "1.0.0"))`

> Note: The package requires iOS v13+

## Other Packages

If you want easy access to this and more packages, add the following collection to your Xcode 13+ configuration:

`https://benkau.com/packages.json`
