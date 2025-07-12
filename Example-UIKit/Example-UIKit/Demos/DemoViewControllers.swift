//
//  DemoViewControllers.swift
//  Example-UIKit
//
//  Created by Hesham Salman on 7/11/25.
//

import SnapKit
import UIKit

// MARK: - Basic Demo View Controllers

class BasicPrimaryViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "Primary View"

    let label = UILabel()
    label.text = "This is the Primary View"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "The primary view is typically used for navigation or as a sidebar in split view layouts."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)
    view.addSubview(descriptionLabel)

    label.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.centerY.equalTo(view).offset(-20)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }

    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(16)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }
  }
}

class BasicSecondaryViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemGroupedBackground
    title = "Secondary View"

    let label = UILabel()
    label.text = "This is the Secondary View"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "The secondary view is typically used to display detailed content or as the main content area."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)
    view.addSubview(descriptionLabel)

    label.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.centerY.equalTo(view).offset(-20)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }

    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(16)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }
  }
}

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
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.bottom.equalTo(view)
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

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNotificationObserver()
    setupDetailItems()
  }

  private func setupUI() {
    view.backgroundColor = .systemGroupedBackground
    title = "Detail"

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
    tableView.register(DetailHeaderCell.self, forCellReuseIdentifier: "HeaderCell")

    // Configure cells to show detail text
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
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
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

    contentView.addSubview(iconImageView)
    contentView.addSubview(titleLabel)

    iconImageView.snp.makeConstraints { make in
      make.top.equalTo(contentView).offset(20)
      make.centerX.equalTo(contentView)
      make.width.height.equalTo(60)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(iconImageView.snp.bottom).offset(16)
      make.leading.equalTo(contentView).offset(20)
      make.trailing.equalTo(contentView).offset(-20)
      make.bottom.equalTo(contentView).offset(-20)
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

    contentView.addSubview(titleLabel)
    contentView.addSubview(valueLabel)

    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(contentView).offset(16)
      make.centerY.equalTo(contentView)
      make.trailing.equalTo(valueLabel.snp.leading).offset(-8)
    }

    valueLabel.snp.makeConstraints { make in
      make.trailing.equalTo(contentView).offset(-16)
      make.centerY.equalTo(contentView)
      make.width.lessThanOrEqualTo(contentView).multipliedBy(0.5)
    }

    contentView.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(44)
    }

    titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }

  func configure(title: String, value: String) {
    titleLabel.text = title
    valueLabel.text = value
  }
}

// MARK: - Custom Layout Demo View Controllers

class CustomPrimaryViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemPurple.withAlphaComponent(0.1)
    title = "Custom Primary"

    let label = UILabel()
    label.text = "Custom Styled Primary View"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textColor = .systemPurple
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "This demonstrates custom styling and layout options for the primary view."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .systemPurple
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)
    view.addSubview(descriptionLabel)

    label.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.centerY.equalTo(view).offset(-20)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }

    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(16)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }
  }
}

class CustomSecondaryViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemOrange.withAlphaComponent(0.1)
    title = "Custom Secondary"

    let label = UILabel()
    label.text = "Custom Styled Secondary View"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textColor = .systemOrange
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "This demonstrates custom styling and layout options for the secondary view."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .systemOrange
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)
    view.addSubview(descriptionLabel)

    label.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.centerY.equalTo(view).offset(-20)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }

    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(16)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }
  }
}

// MARK: - Adaptive Demo View Controllers

class AdaptivePrimaryViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemTeal.withAlphaComponent(0.1)
    title = "Adaptive Primary"

    let label = UILabel()
    label.text = "Adaptive Design Primary"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textColor = .systemTeal
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "This view demonstrates how the split view adapts to different screen sizes and orientations. Try rotating your device or resizing the window."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .systemTeal
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)
    view.addSubview(descriptionLabel)

    label.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.centerY.equalTo(view).offset(-20)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }

    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(16)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }
  }
}

class AdaptiveSecondaryViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemIndigo.withAlphaComponent(0.1)
    title = "Adaptive Secondary"

    let label = UILabel()
    label.text = "Adaptive Design Secondary"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textColor = .systemIndigo
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "Watch how this secondary view changes its layout and behavior based on the available screen space."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .systemIndigo
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)
    view.addSubview(descriptionLabel)

    label.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.centerY.equalTo(view).offset(-20)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }

    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(16)
      make.leading.trailing.equalTo(view.readableContentGuide)
    }
  }
}

// MARK: - Notification Extension

extension Notification.Name {
  static let itemSelected = Notification.Name("itemSelected")
}
