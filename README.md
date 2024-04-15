DDDialog is a SwiftUI library for presenting a dialog

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Example](#example)
- [License](#license)

## Features

- [x] Flexible on set a root point on how dialog to be presented
- [x] Custom animation and transition for each of dialog
- [x] Dismiss by using environment or binding itself
- [x] Support 3 placements: top, center and bottom

## Requirements

| Platform  | Minimum Swift Version | Installation                                                             |
| --------- | --------------------- | ------------------------------------------------------------------------ |
| iOS 14.0+ | 5.0.0 / Xcode 14.1    | [CocoaPods](#cocoapods), [Swift Package Manager](#swift-package-manager) |

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding DDDialog as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift` or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/duyduong/dddialog.git", .upToNextMajor(from: "1.0.0"))
]
```

Normally you'll want to depend on the `DDDialog` target:

```swift
.product(name: "DDDialog", package: "DDDialog")
```

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate DDDialog into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SwiftUIDialog'
```

## Usage

DDDialog is simple to use, just need one more setup setup step then it is ready to use

### Setup root point

To start making DDDialog to work, we need to setup a root point for the dialog to be presented. A root point can be in:

- NavigationView
- TabView
- or the view itself

Basically we call `setupDialogs` in the view that we want the dialog to be covered. The root point can be overriden, the nearest calls setup root point will be used.

For example:

- If we want the dialog to cover the navigation bar, call setup root point in NavigationView (See example project)

```swift
NavigationView {
    ...
}
.setupDialogs()
```

- If we want the dialog to cover the tab bar, call setup root point in TabView (See example project)

```swift
TabView(selection: $selection) {
    ...
}
.setupDialogs()
```

### Present a dialog using `Dialog` protocol binding

DDDialog provides a `Dialog` protocol to let us present different dialog type in the same view

```swift
public protocol Dialog: Hashable {
    var id: String { get }

    /// Dialog placement `top`, `center` or `bottom`
    var placement: DialogPlacement { get }

    /// Dialog overlay (dim background), supports mono color or `UIBlurEffect.Style`
    var overlay: DialogOverlay { get }

    /// Whether allow to tap outside (dim background) to dismiss the dialog
    var shouldDismissOnTapOutside: Bool { get }

    /// Custom dialog animation
    var animation: Animation? { get }

    /// Custom dialog transition
    var transition: AnyTransition? { get }
}
```

The protocol contains neccessary properties to help use define the behavor of a dialog. We just need to define a dialog type to conform `Dialog` protocol, for example

```swift
enum MyDialog: Dialog {
    case top(message: String)
    case center(message: String)
    case bottom(message: String)

    var placement: DialogPlacement {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }

    var shouldDismissOnTapOutside: Bool {
        false
    }

    var overlay: DialogOverlay {
        switch self {
        case .center: return .effect(.dark)
        default: return .color(.black.opacity(0.5))
        }
    }
}
```

Then in view, we can use this modifier to present the dialog

```swift
func dialog<Item: Dialog, Content: View>(
    item: Binding<Item?>,
    @ViewBuilder content: @escaping (Item) -> Content
)
```

Below is the example for using the `Dialog` protocol

```swift
struct ExampleView: View {
    enum MyDialog: Dialog {
        case top(message: String)
        case center(message: String)
        case bottom(message: String)

        var placement: DialogPlacement {
            switch self {
            case .top: return .top
            case .center: return .center
            case .bottom: return .bottom
            }
        }

        var shouldDismissOnTapOutside: Bool {
            false
        }

        var overlay: DialogOverlay {
            switch self {
            case .center: return .effect(.dark)
            default: return .color(.black.opacity(0.5))
            }
        }
    }

    var navigationBarColor: Color = .blue
    @State private var dialog: MyDialog?

    var body: some View {
        if #available(iOS 16, *) {
            contentView
                .toolbarBackground(navigationBarColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        } else {
            contentView
        }
    }

    var contentView: some View {
        VStack(spacing: 16) {
            Button {
                dialog = .top(message: "Example top dialog is showing")
            } label: {
                Text("Show top dialog")
            }

            Button {
                dialog = .center(message: "Example center dialog is showing")
            } label: {
                Text("Show center dialog")
            }

            Button {
                dialog = .bottom(message: "Example bottom dialog is showing")
            } label: {
                Text("Show bottom dialog")
            }
        }
        .dialog(item: $dialog) { // Binding the dialog item for building dialog view
            switch $0 {
            case let .top(message): TopDialogView(message: message)
            case let .center(message): CenterDialogView(message: message)
            case let .bottom(message): BottomDialogView(message: message)
            }
        }
    }
}
```

### Present a dialog using `Bool` binding

Same as `Dialog` protocol, but using `Bool` binding is the useful way to just present one dialog, as define using below modifier

```swift
func dialog<Content: View>(
    isPresented: Binding<Bool>,
    placement: DialogPlacement = .bottom,
    overlay: DialogOverlay = .color(.black.opacity(0.4)),
    shouldDismissOnTapOutside: Bool = true,
    animation: Animation? = nil,
    transition: AnyTransition? = nil,
    @ViewBuilder content: @escaping () -> Content
)
```

It supports all the properties same `Dialog` protocol, below the the example for using `Bool` binding

```swift
struct ExampleView: View {
    var navigationBarColor: Color = .blue
    @State private var isShowingDialog = false

    var body: some View {
        if #available(iOS 16, *) {
            contentView
                .toolbarBackground(navigationBarColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        } else {
            contentView
        }
    }

    var contentView: some View {
        VStack(spacing: 16) {
            Button {
                isShowingDialog = true
            } label: {
                Text("Show center dialog")
            }
        }
        .dialog(isPresented: $isShowingDialog) { // Binding the flag for building the dialog view
            CenterDialogView(message: "Example bottom dialog is showing")
        }
    }
}
```

### Dismiss the dialog manually

It is very easy to dismiss a dialog

- **Dismiss from the place we presented it**: just set the state `dialog` to nil or turn off the bool flag `isShowingDialog = false`
- **Dismiss the dialog from the dialog itself**: DDDialog provides an environment called `dialogPresenter`, we can use it to dismiss. For example

```swift
struct ExampleDialogView: View {
    @Environment(\.dialogPresenter) private var dialogPresenter

    var body: some View {
        Button {
            dialogPresenter.dismiss()
            // or dismiss with a completion
            /* dialogPresenter.dismiss {
                // Handle completion after the animation is finished
            } */
        } label: {
            Text("Dismiss")
        }
    }
}
```

## Example

To see example project, just open `DDDialog.xcworkspace`

## License

DDDialog is released under the MIT license. [See LICENSE](https://github.com/duyduong/dddialog/blob/master/LICENSE) for details.
