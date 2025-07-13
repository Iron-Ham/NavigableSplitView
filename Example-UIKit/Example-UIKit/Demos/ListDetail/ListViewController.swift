import NavigableSplitView
import SnapKit
import UIKit

// MARK: - List-Detail Demo View Controllers

class ListViewController: UIViewController {

  private let items = [
    "Documents", "Downloads", "Music", "Pictures", "Videos",
    "Desktop", "Applications", "Library", "System", "Users",
  ]

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.cellLayoutMarginsFollowReadableWidth = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow,
      traitCollection.horizontalSizeClass == .compact
    {
      tableView.deselectRow(at: indexPath, animated: animated)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "List"

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension ListViewController: SplitViewControllerColumnProviding {
  var preferredCompactColumn: UISplitViewController.Column {
    tableView.indexPathForSelectedRow == nil ? .primary : .secondary
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
    let selectedItem = items[indexPath.row]

    let detailVC = DetailTableViewController(style: .insetGrouped)
    detailVC.configure(with: selectedItem)

    if let splitViewController {
      splitViewController.showDetailViewController(detailVC, sender: self)
    }
  }
}
