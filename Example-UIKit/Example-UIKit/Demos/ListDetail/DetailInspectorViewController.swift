import NavigableSplitView
import SnapKit
import UIKit

protocol DetailInspectorViewControllerDelegate: AnyObject {
  func didDismissInspector()
}

@available(iOS 26.0, *)
class DetailInspectorViewController: UIViewController {

  private var currentItem: String = ""
  private let scrollView = UIScrollView()
  private let contentStackView = UIStackView()

  weak var delegate: DetailInspectorViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNavigationBar()
  }

  private func setupUI() {
    view.backgroundColor = .systemGroupedBackground
    title = "Inspector"

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentStackView.axis = .vertical
    contentStackView.spacing = grid(4)
    contentStackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(scrollView)
    scrollView.addSubview(contentStackView)

    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }

    contentStackView.snp.makeConstraints { make in
      make.edges.equalTo(scrollView).inset(grid(4))
      make.width.equalTo(scrollView).inset(grid(4))
    }
  }

  private func setupNavigationBar() {
    let dismissButton = UIBarButtonItem(
      image: UIImage(systemName: "xmark"),
      style: .plain,
      target: self,
      action: #selector(dismissInspector)
    )
    navigationItem.rightBarButtonItem = dismissButton
  }

  @objc private func dismissInspector() {
    defer {
      delegate?.didDismissInspector()
    }
    if let splitViewController {
      splitViewController.setViewController(nil, for: .inspector)
      splitViewController.hide(.inspector)
    } else {
      dismiss(animated: true)
    }
  }

  func configure(for item: String) {
    currentItem = item
    updateContent()
  }

  private func updateContent() {
    // Clear existing content
    for view in contentStackView.arrangedSubviews {
      view.removeFromSuperview()
    }

    // Header
    let headerView = createHeaderView()
    contentStackView.addArrangedSubview(headerView)

    // Metadata section
    let metadataView = createMetadataView()
    contentStackView.addArrangedSubview(metadataView)

    // Actions section
    let actionsView = createActionsView()
    contentStackView.addArrangedSubview(actionsView)

    // Tools section
    let toolsView = createToolsView()
    contentStackView.addArrangedSubview(toolsView)
  }

  private func createHeaderView() -> UIView {
    let containerView = UIView()
    containerView.backgroundColor = .systemBackground
    containerView.layer.cornerRadius = grid(2)

    let iconImageView = UIImageView()
    iconImageView.image = UIImage(systemName: getIconName(for: currentItem))
    iconImageView.tintColor = .systemBlue
    iconImageView.contentMode = .scaleAspectFit

    let titleLabel = UILabel()
    titleLabel.text = currentItem
    titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    titleLabel.textAlignment = .center

    let subtitleLabel = UILabel()
    subtitleLabel.text = "Inspector View"
    subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.textAlignment = .center

    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(40)
    }

    let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, subtitleLabel])
    stack.axis = .vertical
    stack.spacing = grid(2)
    stack.alignment = .center

    containerView.addSubview(stack)
    stack.snp.makeConstraints { make in
      make.edges.equalTo(containerView).inset(grid(4))
    }

    return containerView
  }

  private func createMetadataView() -> UIView {
    let containerView = createSectionContainer(title: "Metadata")

    let metadata = [
      ("Type", "Folder"),
      ("Size", "\(Int.random(in: 100...999)) items"),
      ("Created", "January 1, 2024"),
      ("Modified", "July 11, 2025"),
      ("Permissions", "Read & Write"),
      ("Location", "/Users/\(currentItem.lowercased())"),
    ]

    for (key, value) in metadata {
      let propertyView = createPropertyView(title: key, value: value)
      containerView.addArrangedSubview(propertyView)
    }

    return containerView
  }

  private func createActionsView() -> UIView {
    let containerView = createSectionContainer(title: "Quick Actions")

    let actions = [
      ("Open", "folder.badge.plus"),
      ("Share", "square.and.arrow.up"),
      ("Copy Path", "doc.on.doc"),
      ("Show in Finder", "magnifyingglass"),
    ]

    for (title, icon) in actions {
      let actionButton = createActionButton(title: title, icon: icon)
      containerView.addArrangedSubview(actionButton)
    }

    return containerView
  }

  private func createToolsView() -> UIView {
    let containerView = createSectionContainer(title: "Developer Tools")

    let tools = [
      "View in Terminal",
      "Git Status",
      "Code Analysis",
      "Performance Monitor",
    ]

    for tool in tools {
      let toolButton = createToolButton(title: tool)
      containerView.addArrangedSubview(toolButton)
    }

    return containerView
  }

  private func createSectionContainer(title: String) -> UIStackView {
    let headerLabel = UILabel()
    headerLabel.text = title
    headerLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    headerLabel.textColor = .label

    let containerStack = UIStackView()
    containerStack.axis = .vertical
    containerStack.spacing = grid(2)
    containerStack.backgroundColor = .systemBackground
    containerStack.layer.cornerRadius = grid(2)
    containerStack.isLayoutMarginsRelativeArrangement = true
    containerStack.layoutMargins = UIEdgeInsets(
      top: grid(3), left: grid(3), bottom: grid(3), right: grid(3))

    containerStack.addArrangedSubview(headerLabel)

    return containerStack
  }

  private func createPropertyView(title: String, value: String) -> UIView {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    titleLabel.textColor = .label

    let valueLabel = UILabel()
    valueLabel.text = value
    valueLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    valueLabel.textColor = .secondaryLabel
    valueLabel.textAlignment = .right

    let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    stack.axis = .horizontal
    stack.distribution = .fill

    titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    return stack
  }

  private func createActionButton(title: String, icon: String) -> UIButton {
    var config = UIButton.Configuration.filled()
    config.title = title
    config.image = UIImage(systemName: icon)
    config.imagePlacement = .leading
    config.imagePadding = grid(2)
    config.contentInsets = NSDirectionalEdgeInsets(
      top: grid(2), leading: grid(3), bottom: grid(2), trailing: grid(3))
    config.baseBackgroundColor = .systemGray6
    config.baseForegroundColor = .label
    config.cornerStyle = .fixed
    config.background.cornerRadius = grid(1)

    let button = UIButton(configuration: config)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)

    button.snp.makeConstraints { make in
      make.height.equalTo(grid(10))
    }

    return button
  }

  private func createToolButton(title: String) -> UIButton {
    var config = UIButton.Configuration.filled()
    config.title = title
    config.contentInsets = NSDirectionalEdgeInsets(
      top: grid(2), leading: grid(3), bottom: grid(2), trailing: grid(3))
    config.baseBackgroundColor = .systemBlue.withAlphaComponent(0.1)
    config.baseForegroundColor = .systemBlue
    config.cornerStyle = .fixed
    config.background.cornerRadius = grid(1)

    let button = UIButton(configuration: config)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    button.contentHorizontalAlignment = .leading

    button.snp.makeConstraints { make in
      make.height.equalTo(grid(10))
    }

    return button
  }

  private func getIconName(for item: String) -> String {
    switch item.lowercased() {
    case "documents":
      "doc.fill"
    case "downloads":
      "arrow.down.circle.fill"
    case "music":
      "music.note"
    case "pictures":
      "photo.fill"
    case "videos":
      "video.fill"
    case "desktop":
      "desktopcomputer"
    case "applications":
      "app.fill"
    case "library":
      "books.vertical.fill"
    case "system":
      "gear.circle.fill"
    case "users":
      "person.2.fill"
    default:
      "folder.fill"
    }
  }
}
