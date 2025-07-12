# NavigableSplitView

A powerful UIKit component that enables seamless integration of split view controllers into navigation hierarchies. Push split views onto navigation stacks just like any other view controller.

## Overview

`NavigableSplitViewController` solves a common problem in iOS development: how to embed a `UISplitViewController` within an existing navigation hierarchy. Traditionally, split view controllers must be root view controllers, but this wrapper allows you to push them onto navigation stacks while maintaining proper navigation behavior and visual consistency.

## Features

- ✅ **Seamless Navigation Integration** - Push split views onto existing navigation stacks
- ✅ **Automatic Back Button Handling** - Smart back button mirroring maintains navigation consistency
- ✅ **Adaptive Layout Support** - Works across all device sizes and orientations
- ✅ **Customizable Display Options** - Configure split behavior and display modes
- ✅ **Pure UIKit Implementation** - No dependencies, works with existing UIKit apps
- ✅ **iOS 26+ Inspector Support** - Three-column layouts with inspector panes
- ✅ **iOS 18 Bug Workarounds** - Built-in fixes for known platform issues

## Requirements

- iOS 18.0+
- Swift 6.2+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add NavigableSplitView to your project using Xcode:

1. File → Add Package Dependencies...
2. Enter the repository URL: `https://github.com/Iron-Ham/NavigableSplitView`
3. Select the version requirements
4. Add to your target

Alternatively, add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Iron-Ham/NavigableSplitView", from: "1.0.0")
]
```

## Quick Start

### Basic Usage

```swift
import NavigableSplitView

// Create your primary and secondary view controllers
let primaryVC = YourPrimaryViewController()
let secondaryVC = YourSecondaryViewController()

// Create the navigable split view
let splitView = NavigableSplitViewController(
    primary: primaryVC,
    secondary: secondaryVC
)

// Push it onto your navigation stack
navigationController.pushViewController(splitView, animated: true)
```

### Advanced Configuration

```swift
// Access the underlying split view controller for advanced configuration
splitView.splitVC.preferredDisplayMode = .oneBesideSecondary
splitView.splitVC.preferredSplitBehavior = .tile

// Access individual view controllers
if let primaryVC = splitView.primaryViewController {
    // Configure primary view controller
}

if let secondaryVC = splitView.secondaryViewController {
    // Configure secondary view controller
}

// iOS 26+ Inspector support
if #available(iOS 26.0, *) {
    let inspectorVC = YourInspectorViewController()
    splitView.splitVC.setViewController(inspectorVC, for: .inspector)
}
```

### Navigation Integration

The component automatically handles navigation bar management:

- Hides the navigation bar when the split view appears
- Restores the navigation bar when leaving the split view
- Mirrors back buttons for consistent navigation behavior
- Handles compact mode navigation appropriately

## Architecture

### Core Components

- **`NavigableSplitViewController`** - Main wrapper class that makes split views navigable
- **`CustomUISplitViewController`** - Internal subclass with enhanced delegate handling and iOS 18 bug fixes
- **`SplitViewControllerColumnProviding`** - Protocol for view controllers that need column awareness

### Key Concepts

1. **Navigation Wrapping**: The split view controller is embedded as a child view controller
2. **Back Button Mirroring**: Automatic back button management maintains navigation consistency
3. **Adaptive Behavior**: Responsive design that works across all device configurations
4. **Platform Workarounds**: Built-in fixes for iOS 18 bugs and platform limitations

## Example App

The included example app demonstrates various use cases:

- **Basic Split View** - Simple primary/secondary layout
- **List-Detail Navigation** - Master-detail flow with navigation
- **Inspector Integration** - Three-column layout with inspector (iOS 26+)
- **Complex Hierarchies** - Nested navigation scenarios
- **About Screen** - Modern UITableView-based settings interface

To run the example:

1. Clone the repository
2. Open `Example-UIKit/Example-UIKit.xcodeproj`
3. Build and run the target

## API Reference

### NavigableSplitViewController

#### Initialization

```swift
init(primary: UIViewController, secondary: UIViewController?)
```

Creates a new navigable split view with primary and optional secondary view controllers.

#### Properties

```swift
var primaryViewController: UIViewController? { get }
var secondaryViewController: UIViewController? { get }
var splitVC: UISplitViewController { get }
var displayMode: UISplitViewController.DisplayMode { get }
var isCompact: Bool { get }
```

#### iOS 26+ Properties

```swift
@available(iOS 26.0, *)
var inspectorViewController: UIViewController? { get }
```

### SplitViewControllerColumnProviding

```swift
protocol SplitViewControllerColumnProviding: UIViewController {
    var column: UISplitViewController.Column { get }
}
```

Implement this protocol in view controllers that need to know which column they represent.

## Best Practices

### 1. Navigation Hierarchy Planning

```swift
// ✅ Good: Clear hierarchy
NavigationController
├── RootViewController
├── ListViewController
└── NavigableSplitViewController
    ├── PrimaryViewController
    └── SecondaryViewController
```

### 2. Responsive Design

```swift
// Handle different display modes
switch splitView.displayMode {
case .oneBesideSecondary:
    // Both panes visible
case .oneOverSecondary:
    // Overlay mode
case .automatic:
    // System-determined
}
```

### 3. Memory Management

```swift
// The wrapper automatically manages child view controllers
// No manual cleanup required when popping from navigation stack
```

### 4. Inspector Usage (iOS 26+)

```swift
// Show inspector with proper error handling
if #available(iOS 26.0, *) {
    let inspectorVC = InspectorViewController()
    splitView.splitVC.setViewController(inspectorVC, for: .inspector)
    splitView.splitVC.show(.inspector)
}
```

## Platform Considerations

### iOS 18 Bug Workarounds

The library includes automatic workarounds for known iOS 18 issues:

- **showDetailViewController crash**: Fixed when secondary view controller is nil
- **Navigation bar conflicts**: Resolved through careful state management
- **Compact mode transitions**: Proper handling of layout changes

### iOS 26+ Features

- **Inspector support**: Three-column layouts with inspector panes
- **Enhanced split behaviors**: Additional display modes and configurations
- **Improved adaptive layouts**: Better handling of size class transitions

## Troubleshooting

### Common Issues

**Q: Split view doesn't appear correctly in compact mode**
A: The component includes automatic workarounds for iOS platform bugs. Ensure you're using the latest version.

**Q: Back navigation doesn't work as expected**
A: Ensure your primary view controller doesn't have conflicting navigation items. The wrapper handles back button mirroring automatically.

**Q: Navigation bar appears when it shouldn't**
A: The component manages navigation bar visibility automatically. Avoid manual navigation bar modifications within the split view hierarchy.

**Q: Inspector doesn't show in compact mode**
A: Inspector views are only available in regular size classes. The component automatically handles this limitation.

## Contributing

We welcome contributions! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

1. Clone the repository
2. Open the package in Xcode
3. Run tests: `⌘+U`
4. Build the example app to test changes

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by common navigation challenges in iOS development
- Built with modern iOS development practices
- Designed for seamless integration with existing codebases

---

**Need help?** Open an issue on GitHub or check the example app for implementation patterns.
