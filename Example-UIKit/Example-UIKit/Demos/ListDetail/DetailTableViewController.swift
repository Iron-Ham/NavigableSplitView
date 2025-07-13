import NavigableSplitView
import SnapKit
import UIKit

class DetailTableViewController: UITableViewController {

  private var selectedItem: String = "Select an item"
  private var detailItems: [String] = []
  lazy var inspectorButton = UIBarButtonItem(
    image: UIImage(systemName: "sidebar.right"),
    style: .plain,
    target: self,
    action: #selector(showInspector)
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupDetailItems()
    setupNavigationBar()
    inspectorButton.isHidden = selectedItem == "Select an item"
    registerForTraitChanges([UITraitHorizontalSizeClass.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
      self.setupNavigationBar()
    }
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

  func configure(with item: String) {
    selectedItem = item
    if isViewLoaded {
      tableView.reloadData()
      updateInspectorButtonVisibility()

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

  private func setupNavigationBar() {
    let image = if self.traitCollection.horizontalSizeClass == .compact {
      UIImage(systemName: "info.circle")
    } else {
      UIImage(systemName: "sidebar.right")
    }
    self.inspectorButton = UIBarButtonItem(
      image: image,
      style: .plain,
      target: self,
      action: #selector(self.showInspector)
    )
    navigationItem.rightBarButtonItem = inspectorButton
    updateInspectorButtonVisibility()
  }

  func updateInspectorButtonVisibility() {
    if #available(iOS 26.0, *), let splitViewController {
      inspectorButton.isHidden = splitViewController.isShowing(.inspector)
    } else if traitCollection.horizontalSizeClass == .compact, let tabBarController {
      inspectorButton.isHidden = tabBarController.presentedViewController != nil
    }
  }

  @objc private func showInspector() {
    guard #available(iOS 26.0, *),
      selectedItem != "Select an item"
    else { return }

    let inspectorVC = DetailInspectorViewController()
    inspectorVC.delegate = self
    inspectorVC.configure(for: selectedItem)
    splitViewController?.setViewController(inspectorVC, for: .inspector)
    splitViewController?.show(.inspector)
    inspectorButton.isHidden = true
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    3
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      // Header section
      1
    case 1:
      // Details section
      selectedItem == "Select an item" ? 1 : detailItems.count
    case 2:
      // Navigation buttons section
      selectedItem == "Select an item" ? 0 : 2
    default:
      0
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
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
      cell.selectionStyle = .default
      cell.accessoryType = .disclosureIndicator
      cell.textLabel?.textColor = .systemBlue

      if indexPath.row == 0 {
        cell.textLabel?.text = "Push Another List View"
      } else {
        cell.textLabel?.text = "Push Split View Controller"
      }
      return cell
    default:
      return UITableViewCell()
    }
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
  {
    switch section {
    case 1:
      selectedItem == "Select an item" ? nil : "Details"
    case 2:
      selectedItem == "Select an item" ? nil : "Navigation Examples"
    default:
      nil
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 2:
      switch indexPath.row {
      case 0:
        // In a real application, use a router of some sort to decide how/when to do this.
        if let splitViewController,
          let navigation = splitViewController.parent?.navigationController
        {
          navigation.pushViewController(ListViewController(), animated: true)
        } else {
          navigationController?.pushViewController(ListViewController(), animated: true)
        }
      case 1:
        let newSplitViewController = NavigableSplitViewController(
          primary: ListViewController(),
          secondary: DetailTableViewController()
        )
        // In a real application, use a router of some sort to decide how/when to do this.
        if let splitViewController,
          let navigation = splitViewController.parent?.navigationController
        {
          navigation.pushViewController(newSplitViewController, animated: true)
        } else {
          navigationController?.pushViewController(newSplitViewController, animated: true)
        }
      default:
        break
      }
    default:
      break
    }
  }

  private func getDetailValue(for property: String, item: String) -> String {
    switch property {
    case "Properties":
      "Folder"
    case "Size":
      "\(Int.random(in: 10...999)) items"
    case "Created":
      "January 1, 2024"
    case "Modified":
      "July 11, 2025"
    case "Permissions":
      "Read & Write"
    case "Location":
      "/Users/\(item.lowercased())"
    default:
      "Unknown"
    }
  }
}

extension DetailTableViewController: DetailInspectorViewControllerDelegate {
  func didDismissInspector() {
    inspectorButton.isHidden = false
  }
}

// MARK: - Custom Header Cell

private class DetailHeaderCell: UITableViewCell {

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

private class DetailInfoCell: UITableViewCell {

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
