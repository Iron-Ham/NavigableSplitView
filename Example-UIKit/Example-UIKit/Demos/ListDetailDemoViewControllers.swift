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

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNotificationObserver()
    setupDetailItems()
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

// MARK: - Notification Extension

extension Notification.Name {
  static let itemSelected = Notification.Name("itemSelected")
}
