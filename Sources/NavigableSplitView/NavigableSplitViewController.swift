import UIKit

/// A wrapper that allows a `UISplitViewController` to be pushed onto an existing navigation hierarchy.
///
/// This class enables seamless integration of split view controllers into navigation stacks
/// by wrapping the split view functionality in a standard `UIViewController` that can be
/// pushed and popped like any other view controller. It handles navigation bar management
/// and provides automatic back button mirroring to maintain consistent navigation behavior.
open class NavigableSplitViewController: UIViewController {

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

  var isCompact: Bool { splitVC.isCollapsed }

  /// The current display mode of the split view controller.
  ///
  /// This property reflects how the split view is currently being displayed,
  /// such as whether both panes are visible side-by-side or if only one is shown.
  /// The value corresponds to `UISplitViewController.DisplayMode` options.
  public var displayMode: UISplitViewController.DisplayMode {
    splitVC.displayMode
  }

  /// Flag to track if the view controller has fully appeared and is ready for split view operations
  var isReadyForSplitViewOperations = false

  /// Queue to store deferred split view operations until the view controller is ready
  var deferredOperations: [() -> Void] = []

  private var primaryNavHasBackStack: Bool {
    if let primaryNavController = primaryViewController as? UINavigationController,
      primaryNavController.viewControllers.count > 1
    {
      true
    } else {
      false
    }
  }

  private weak var splitViewControllerColumnProviding: SplitViewControllerColumnProviding?

  /// Initializes a new navigable split view controller with primary and optional secondary view controllers.
  ///
  /// Creates a split view controller configured with double column style and tile behavior.
  /// The secondary view controller setup may be deferred on iOS 26+ in compact mode to work
  /// around a beta bug that causes infinite logging loops.
  ///
  /// - Parameters:
  ///   - primary: The primary (master/sidebar) view controller to display
  ///   - secondary: The secondary (detail) view controller to display. Can be `nil`
  ///   - customConfiguration: A closure allowing you to customize the behavior of the underlying `UISplitViewController`
  public init(
    primary: SplitViewControllerColumnProviding,
    secondary: UIViewController,
    customConfiguration: ((UISplitViewController) -> Void)? = nil
  ) {
    self.splitViewControllerColumnProviding = primary
    self._splitVC = CustomUISplitViewController(style: .doubleColumn)
    super.init(nibName: nil, bundle: nil)

    // Establish the connection for deferred operations
    _splitVC.navigableSplitViewController = self

    splitVC.preferredDisplayMode = .oneBesideSecondary
    splitVC.preferredSplitBehavior = .tile
    splitVC.delegate = self
    splitVC.setViewController(primary, for: .primary)
    // Possible iOS 26 Beta Bug:
    // This must be deferred until after `viewDidAppear`, or we will end up in an infinite
    // logging loop, which consumes all system resources. This only applies in compact mode.
    // https://developer.apple.com/forums/thread/792740#792740021
    if #available(iOS 26.0, *), traitCollection.horizontalSizeClass == .compact {
      deferredOperations.append { [weak self] in
        guard let self,
          let splitViewControllerColumnProviding,
          splitViewControllerColumnProviding.preferredCompactColumn == .secondary
        else { return }
        self.splitVC.showDetailViewController(secondary, sender: nil)
      }
    } else {
      splitVC.setViewController(secondary, for: .secondary)
    }
  }

  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle

  /// Called after the controller's view is loaded into memory.
  ///
  /// Sets up the split view controller as a child view controller, configures
  /// layout constraints, sets the title, and initializes back button mirroring
  /// for navigation consistency.
  open override func viewDidLoad() {
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
    title = secondaryViewController?.title ?? primaryViewController?.title
    setupBackButtonMirroring()
  }

  /// Called every time the view is about to appear.
  ///
  /// Hides the navigation bar with animation to provide a full-screen
  /// split view experience without conflicting navigation elements.
  ///
  /// - Parameter animated: Whether the appearance should be animated
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  /// Called every time the view is about to disappear.
  ///
  /// Restores the navigation bar visibility with animation when leaving
  /// the split view to maintain normal navigation behavior in other views.
  /// Also resets the readiness flag for split view operations.
  ///
  /// - Parameter animated: Whether the disappearance should be animated
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)

    // Reset readiness flag when transitioning away
    isReadyForSplitViewOperations = false
  }

  /// Called after the view has appeared on screen.
  ///
  /// Handles deferred setup of the secondary view controller on iOS 26+ in compact mode.
  /// This works around a beta bug where immediate setup causes infinite logging loops.
  ///
  /// - Parameter animated: Whether the appearance was animated
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // Mark as ready for split view operations
    isReadyForSplitViewOperations = true

    // Process any deferred operations
    DispatchQueue.main.async {
      for operation in self.deferredOperations {
        operation()
      }
      self.deferredOperations.removeAll()
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
        to: primaryViewController,
        includeBackButton: isBackButtonVisible(for: .primary)
      )
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

extension NavigableSplitViewController: UISplitViewControllerDelegate {
  open func splitViewController(
    _ splitViewController: UISplitViewController,
    showDetail vc: UIViewController,
    sender: Any?
  ) -> Bool {
    if let secondaryViewController {
      secondaryViewController.navigationController?.viewControllers = []
    }
    return false
  }

  public func splitViewController(
    _ svc: UISplitViewController,
    topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
  ) -> UISplitViewController.Column {
    splitViewControllerColumnProviding?.preferredCompactColumn ?? .secondary
  }
}
