import UIKit

/// A wrapper that allows a `UISplitViewController` to be pushed onto an existing navigation hierarchy.
///
/// This class enables seamless integration of split view controllers into navigation stacks
/// by wrapping the split view functionality in a standard `UIViewController` that can be
/// pushed and popped like any other view controller. It handles navigation bar management
/// and provides automatic back button mirroring to maintain consistent navigation behavior.
public class NavigableSplitViewController: UIViewController {

  /// The primary view controller displayed in the split view.
  ///
  /// This is typically the master or sidebar view controller in a split view layout.
  /// Returns `nil` if no primary view controller is set.
  public var primaryViewController: UIViewController? {
    splitVC.viewController(for: .primary)
  }

  /// The secondary view controller displayed in the split view.
  ///
  /// This is typically the detail view controller in a split view layout.
  /// Returns `nil` if no secondary view controller is set.
  public var secondaryViewController: UIViewController? {
    splitVC.viewController(for: .secondary)
  }

  /// The inspector view controller displayed in the split view.
  ///
  /// This is an additional pane that can be shown in supported layouts.
  /// Only available on iOS 26.0 and later. Returns `nil` if no inspector
  /// view controller is set or if the iOS version doesn't support it.
  @available(iOS 26.0, *)
  public var inspectorViewController: UIViewController? {
    splitVC.viewController(for: .inspector)
  }

  private let _splitVC: CustomUISplitViewController

  public var splitVC: UISplitViewController { _splitVC }

  var isCompact: Bool {
    splitVC.isCollapsed
  }

  /// The current display mode of the split view controller.
  ///
  /// This property reflects how the split view is currently being displayed,
  /// such as whether both panes are visible side-by-side or if only one is shown.
  /// The value corresponds to `UISplitViewController.DisplayMode` options.
  public var displayMode: UISplitViewController.DisplayMode {
    splitVC.displayMode
  }

  private var deferredSecondaryViewController: UIViewController?

  private var primaryNavHasBackStack: Bool {
    if let primaryNavController = primaryViewController as? UINavigationController,
      primaryNavController.viewControllers.count > 1
    {
      true
    } else {
      false
    }
  }

  /// Initializes a new navigable split view controller with primary and optional secondary view controllers.
  ///
  /// Creates a split view controller configured with double column style and tile behavior.
  /// The secondary view controller setup may be deferred on iOS 26+ in compact mode to work
  /// around a beta bug that causes infinite logging loops.
  ///
  /// - Parameters:
  ///   - primary: The primary (master/sidebar) view controller to display
  ///   - secondary: The secondary (detail) view controller to display. Can be `nil`
  public init(
    primary: UIViewController,
    secondary: UIViewController?
  ) {
    self._splitVC = CustomUISplitViewController(style: .doubleColumn)
    super.init(nibName: nil, bundle: nil)
    splitVC.preferredDisplayMode = .oneBesideSecondary
    splitVC.preferredSplitBehavior = .tile
    splitVC.setViewController(primary, for: .primary)
    // Possible iOS 26 Beta Bug:
    // This must be deferred until after `viewDidAppear`, or we will end up in an infinite
    // logging loop, which consumes all system resources. This only applies in compact mode.
    //
    // On older systems, this works as intended.
    // https://developer.apple.com/forums/thread/792740#792740021
    if #available(iOS 26.0, *), traitCollection.horizontalSizeClass == .compact {
      self.deferredSecondaryViewController = secondary
    } else {
      splitVC.setViewController(secondary, for: .secondary)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle

  /// Called after the controller's view is loaded into memory.
  ///
  /// Sets up the split view controller as a child view controller, configures
  /// layout constraints, sets the title, and initializes back button mirroring
  /// for navigation consistency.
  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    addChild(splitVC)
    view.addSubview(splitVC.view)
    splitVC.didMove(toParent: self)

    splitVC.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      splitVC.view.topAnchor.constraint(equalTo: view.topAnchor),
      splitVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      splitVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      splitVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    title = "Split View"

    setupBackButtonMirroring()
  }

  /// Called every time the view is about to appear.
  ///
  /// Hides the navigation bar with animation to provide a full-screen
  /// split view experience without conflicting navigation elements.
  ///
  /// - Parameter animated: Whether the appearance should be animated
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  /// Called every time the view is about to disappear.
  ///
  /// Restores the navigation bar visibility with animation when leaving
  /// the split view to maintain normal navigation behavior in other views.
  ///
  /// - Parameter animated: Whether the disappearance should be animated
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  /// Called after the view has appeared on screen.
  ///
  /// Handles deferred setup of the secondary view controller on iOS 26+ in compact mode.
  /// This works around a beta bug where immediate setup causes infinite logging loops.
  ///
  /// - Parameter animated: Whether the appearance was animated
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let deferredSecondaryViewController {
      DispatchQueue.main.async {
        self.splitVC.showDetailViewController(deferredSecondaryViewController, sender: nil)
      }
    }
  }

  private func isBackButtonVisible(for column: UISplitViewController.Column) -> Bool {
    let hasParent = (navigationController?.viewControllers.count ?? 0) > 1
    switch column {
    case .primary:
      if primaryNavHasBackStack {
        return false  // The standard backstack will handle
      } else {
        return hasParent
      }
    case .supplementary:
      fatalError("We do not support threeColumn layouts")
    case .secondary:
      return false
    case .compact:
      return hasParent
    case .inspector:
      return false
    @unknown default:
      return hasParent
    }
  }

  private func setupBackButtonMirroring() {
    guard let navController = navigationController,
      navController.viewControllers.count > 1
    else {
      return
    }

    if let primaryViewController {
      addNavigationButtons(
        to: primaryViewController, includeBackButton: isBackButtonVisible(for: .primary))
    }
  }

  private func addNavigationButtons(to viewController: UIViewController, includeBackButton: Bool) {
    var leadingGroups: [UIBarButtonItemGroup] = []
    let existingGroups = viewController.navigationItem.leadingItemGroups

    // Add back button in its own group
    if includeBackButton {
      let backButton = UIBarButtonItem(
        image: UIImage(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: #selector(backButtonTapped)
      )
      let backButtonGroup = UIBarButtonItemGroup(
        barButtonItems: [backButton],
        representativeItem: nil
      )
      leadingGroups.append(backButtonGroup)
    }

    viewController.navigationItem.leadingItemGroups = leadingGroups + existingGroups
  }

  @objc private func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
}
