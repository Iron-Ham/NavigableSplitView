//
//  ListDetailDemoViewControllers.swift
//  Example-UIKit
//
//  Created by Hesham Salman on 7/11/25.
//

import SnapKit
import UIKit

// MARK: - List-Detail Demo View Controllers

class ListViewController: UIViewController {

  private let items = [
    "Documents", "Downloads", "Music", "Pictures", "Videos",
    "Desktop", "Applications", "Library", "System", "Users",
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "List"

    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.cellLayoutMarginsFollowReadableWidth = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = items[indexPath.row]
    cell.accessoryType = .disclosureIndicator
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // In a real app, this would update the detail view
    NotificationCenter.default.post(name: .itemSelected, object: items[indexPath.row])
  }
}

class DetailTableViewController: UITableViewController {

  private var selectedItem: String = "Select an item"
  private var detailItems: [String] = []
  var inspectorButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNotificationObserver()
    setupDetailItems()
    setupNavigationBar()
  }

  private func setupUI() {
    view.backgroundColor = .systemGroupedBackground
    title = "Detail"

    tableView.cellLayoutMarginsFollowReadableWidth = true
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
    tableView.register(DetailHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
    tableView.register(DetailInfoCell.self, forCellReuseIdentifier: "InfoCell")
  }

  private func setupDetailItems() {
    detailItems = [
      "Properties",
      "Size",
      "Created",
      "Modified",
      "Permissions",
      "Location",
    ]
  }

  private func setupNotificationObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(itemSelected(_:)),
      name: .itemSelected,
      object: nil
    )
  }

  @objc private func itemSelected(_ notification: Notification) {
    guard let item = notification.object as? String else { return }
    selectedItem = item
    DispatchQueue.main.async {
      self.tableView.reloadData()
      self.updateInspectorButtonVisibility()

      // Update inspector if it's currently visible
      if #available(iOS 26.0, *),
        let splitViewController = self.splitViewController,
        let inspectorVC = splitViewController.viewController(for: .inspector)
          as? DetailInspectorViewController,
        splitViewController.isShowing(.inspector)
      {
        inspectorVC.configure(for: item)
      }
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private func setupNavigationBar() {
    inspectorButton = UIBarButtonItem(
      image: UIImage(systemName: "sidebar.right"),
      style: .plain,
      target: self,
      action: #selector(showInspector)
    )
    navigationItem.rightBarButtonItem = inspectorButton
    updateInspectorButtonVisibility()
  }

  func updateInspectorButtonVisibility() {
    if #available(iOS 26.0, *), let splitViewController {
      inspectorButton.isHidden = splitViewController.isShowing(.inspector)
    } else {
      inspectorButton.isHidden = true
    }
  }

  @objc private func showInspector() {
    guard #available(iOS 26.0, *),
      selectedItem != "Select an item"
    else { return }

    let inspectorVC = DetailInspectorViewController()
    inspectorVC.configure(for: selectedItem)
    splitViewController?.setViewController(inspectorVC, for: .inspector)
    splitViewController?.show(.inspector)
    inspectorButton.isHidden = true
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1  // Header section
    case 1:
      return selectedItem == "Select an item" ? 1 : detailItems.count
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    switch indexPath.section {
    case 0:
      let cell =
        tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
        as! DetailHeaderCell
      cell.configure(with: selectedItem)
      return cell
    case 1:
      if selectedItem == "Select an item" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.textLabel?.text = "Choose an item from the list to see details here"
        cell.detailTextLabel?.text = nil
        cell.textLabel?.textColor = .secondaryLabel
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
      } else {
        let cell =
          tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
          as! DetailInfoCell
        let detailItem = detailItems[indexPath.row]
        cell.configure(
          title: detailItem, value: getDetailValue(for: detailItem, item: selectedItem))
        return cell
      }
    default:
      return UITableViewCell()
    }
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
  {
    switch section {
    case 1:
      return selectedItem == "Select an item" ? nil : "Details"
    default:
      return nil
    }
  }

  private func getDetailValue(for property: String, item: String) -> String {
    switch property {
    case "Properties":
      return "Folder"
    case "Size":
      return "\(Int.random(in: 10...999)) items"
    case "Created":
      return "January 1, 2024"
    case "Modified":
      return "July 11, 2025"
    case "Permissions":
      return "Read & Write"
    case "Location":
      return "/Users/\(item.lowercased())"
    default:
      return "Unknown"
    }
  }
}

// MARK: - Custom Header Cell

class DetailHeaderCell: UITableViewCell {

  private let titleLabel = UILabel()
  private let iconImageView = UIImageView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    selectionStyle = .none
    backgroundColor = .clear

    iconImageView.tintColor = .systemBlue
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.translatesAutoresizingMaskIntoConstraints = false

    titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    iconImageView.snp.makeConstraints { make in
      make.width.height.equalTo(60)
    }

    let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
    stack.spacing = grid(4)
    stack.axis = .vertical
    stack.alignment = .center

    contentView.addSubview(stack)
    stack.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(contentView.layoutMarginsGuide)
      make.verticalEdges.equalTo(contentView).inset(grid(5))
    }
  }

  func configure(with item: String) {
    titleLabel.text = item

    let iconName: String
    switch item.lowercased() {
    case "documents":
      iconName = "doc.fill"
    case "downloads":
      iconName = "arrow.down.circle.fill"
    case "music":
      iconName = "music.note"
    case "pictures":
      iconName = "photo.fill"
    case "videos":
      iconName = "video.fill"
    case "desktop":
      iconName = "desktopcomputer"
    case "applications":
      iconName = "app.fill"
    case "library":
      iconName = "books.vertical.fill"
    case "system":
      iconName = "gear.circle.fill"
    case "users":
      iconName = "person.2.fill"
    default:
      iconName = "folder.fill"
    }

    iconImageView.image = UIImage(systemName: iconName)
  }
}

// MARK: - Custom Info Cell

class DetailInfoCell: UITableViewCell {

  private let titleLabel = UILabel()
  private let valueLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    selectionStyle = .none

    titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    titleLabel.textColor = .label
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    valueLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    valueLabel.textColor = .secondaryLabel
    valueLabel.textAlignment = .right
    valueLabel.translatesAutoresizingMaskIntoConstraints = false

    let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    stack.spacing = grid(2)
    stack.axis = .horizontal
    stack.distribution = .fill

    contentView.addSubview(stack)
    stack.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(contentView.layoutMarginsGuide)
      make.verticalEdges.equalTo(contentView).inset(grid(2))
      make.height.greaterThanOrEqualTo(grid(11))
    }

    titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    valueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
  }

  func configure(title: String, value: String) {
    titleLabel.text = title
    valueLabel.text = value
  }
}

// MARK: - Detail Inspector View Controller

@available(iOS 26.0, *)
class DetailInspectorViewController: UIViewController {

  private var currentItem: String = ""
  private let scrollView = UIScrollView()
  private let contentStackView = UIStackView()

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
    guard let splitViewController else { return }
    splitViewController.setViewController(nil, for: .inspector)
    splitViewController.hide(.inspector)
    if let detailVC = splitViewController.viewController(for: .secondary)
      as? DetailTableViewController
    {
      detailVC.inspectorButton.isHidden = false
    }
  }

  func configure(for item: String) {
    currentItem = item
    updateContent()
  }

  private func updateContent() {
    // Clear existing content
    contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

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
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.setImage(UIImage(systemName: icon), for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    button.backgroundColor = .systemGray6
    button.layer.cornerRadius = grid(1)
    button.contentHorizontalAlignment = .left
    button.contentEdgeInsets = UIEdgeInsets(
      top: grid(2), left: grid(3), bottom: grid(2), right: grid(3))
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: grid(2))

    button.snp.makeConstraints { make in
      make.height.equalTo(grid(10))
    }

    return button
  }

  private func createToolButton(title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    button.backgroundColor = .systemBlue.withAlphaComponent(0.1)
    button.setTitleColor(.systemBlue, for: .normal)
    button.layer.cornerRadius = grid(1)
    button.contentHorizontalAlignment = .left
    button.contentEdgeInsets = UIEdgeInsets(
      top: grid(2), left: grid(3), bottom: grid(2), right: grid(3))

    button.snp.makeConstraints { make in
      make.height.equalTo(grid(10))
    }

    return button
  }

  private func getIconName(for item: String) -> String {
    switch item.lowercased() {
    case "documents": return "doc.fill"
    case "downloads": return "arrow.down.circle.fill"
    case "music": return "music.note"
    case "pictures": return "photo.fill"
    case "videos": return "video.fill"
    case "desktop": return "desktopcomputer"
    case "applications": return "app.fill"
    case "library": return "books.vertical.fill"
    case "system": return "gear.circle.fill"
    case "users": return "person.2.fill"
    default: return "folder.fill"
    }
  }
}

// MARK: - Notification Extension

extension Notification.Name {
  static let itemSelected = Notification.Name("itemSelected")
}
