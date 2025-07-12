import UIKit

class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
    configureTabBarAppearance()
    configureSidebar()
  }

  private func setupTabs() {
    let homeTab = UITab(
      title: "Home",
      image: UIImage(systemName: "house"),
      identifier: "home"
    ) { _ in
      let navController = UINavigationController(rootViewController: HomeViewController())
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let splitViewDemoTab = UITab(
      title: "Split View Demos",
      image: UIImage(systemName: "rectangle.split.2x1"),
      identifier: "splitView"
    ) { _ in
      let navController = UINavigationController(rootViewController: SplitViewDemoViewController())
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let aboutTab = UITab(
      title: "About",
      image: UIImage(systemName: "info.circle"),
      identifier: "about"
    ) { _ in
      let navController = UINavigationController(rootViewController: AboutViewController())
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    // Create additional tabs for demonstration
    let settingsTab = UITab(
      title: "Settings",
      image: UIImage(systemName: "gear"),
      identifier: "settings"
    ) { _ in
      let settingsVC = self.createSettingsViewController()
      let navController = UINavigationController(rootViewController: settingsVC)
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let documentsTab = UITab(
      title: "Documents",
      image: UIImage(systemName: "doc.text"),
      identifier: "documents"
    ) { _ in
      let documentsVC = self.createDocumentsViewController()
      let navController = UINavigationController(rootViewController: documentsVC)
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let favoritesTab = UITab(
      title: "Favorites",
      image: UIImage(systemName: "heart"),
      identifier: "favorites"
    ) { _ in
      let favoritesVC = self.createFavoritesViewController()
      let navController = UINavigationController(rootViewController: favoritesVC)
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let projectsTab = UITab(
      title: "Projects",
      image: UIImage(systemName: "folder"),
      identifier: "projects"
    ) { _ in
      let projectsVC = self.createProjectsViewController()
      let navController = UINavigationController(rootViewController: projectsVC)
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    // Set all tabs
    tabs = [
      homeTab, splitViewDemoTab, aboutTab, settingsTab, documentsTab, favoritesTab, projectsTab,
    ]

    // Configure reordering
    configureSidebarReordering()
  }

  private func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground

    tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    }

    tabBar.tintColor = .systemBlue
  }

  private func configureSidebar() {
    // Enable sidebar mode
    mode = .tabSidebar

    // Configure sidebar appearance
    sidebar.isHidden = false
  }

  private func configureSidebarReordering() {

    // Add edit button to the sidebar
    addEditButtonToSidebar()
  }

  private func addEditButtonToSidebar() {
    // Create a custom header view for the sidebar
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 60))
    headerView.backgroundColor = .systemGroupedBackground

    let titleLabel = UILabel()
    titleLabel.text = "NavigableSplitView"
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    let editButton = UIButton(type: .system)
    editButton.setTitle("Edit", for: .normal)
    editButton.setTitle("Done", for: .selected)
    editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    editButton.translatesAutoresizingMaskIntoConstraints = false

    headerView.addSubview(titleLabel)
    headerView.addSubview(editButton)

    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
      titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

      editButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
      editButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
    ])

    // Store reference to edit button for state updates
    editButton.tag = 999  // Use tag to find button later
  }

  @objc private func editButtonTapped(_ sender: UIButton) {
    sender.isSelected.toggle()

    // Animate the button state change
    UIView.animate(withDuration: 0.25) {
      sender.layoutIfNeeded()
    }
  }

  // MARK: - Helper Methods for Creating View Controllers

  private func createSettingsViewController() -> UIViewController {
    let settingsVC = UIViewController()
    settingsVC.title = "Settings"
    settingsVC.view.backgroundColor = .systemGroupedBackground

    let label = UILabel()
    label.text = "Settings"
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    settingsVC.view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: settingsVC.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: settingsVC.view.centerYAnchor),
    ])

    return settingsVC
  }

  private func createDocumentsViewController() -> UIViewController {
    let documentsVC = UIViewController()
    documentsVC.title = "Documents"
    documentsVC.view.backgroundColor = .systemGroupedBackground

    let label = UILabel()
    label.text = "Documents"
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    documentsVC.view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: documentsVC.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: documentsVC.view.centerYAnchor),
    ])

    return documentsVC
  }

  private func createFavoritesViewController() -> UIViewController {
    let favoritesVC = UIViewController()
    favoritesVC.title = "Favorites"
    favoritesVC.view.backgroundColor = .systemGroupedBackground

    let label = UILabel()
    label.text = "Favorites"
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    favoritesVC.view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: favoritesVC.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: favoritesVC.view.centerYAnchor),
    ])

    return favoritesVC
  }

  private func createProjectsViewController() -> UIViewController {
    let projectsVC = UIViewController()
    projectsVC.title = "Projects"
    projectsVC.view.backgroundColor = .systemGroupedBackground

    let label = UILabel()
    label.text = "Projects"
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    projectsVC.view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: projectsVC.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: projectsVC.view.centerYAnchor),
    ])

    return projectsVC
  }
}
