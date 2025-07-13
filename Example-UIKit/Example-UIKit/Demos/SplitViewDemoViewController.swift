//
//  SplitViewDemoViewController.swift
//  Example-UIKit
//
//  Created by Hesham Salman on 7/11/25.
//

import NavigableSplitView
import SnapKit
import UIKit

class SplitViewDemoViewController: UIViewController {

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(DemoTableViewCell.self, forCellReuseIdentifier: "DemoCell")
    tableView.cellLayoutMarginsFollowReadableWidth = true
    return tableView
  }()

  struct DemoItem {
    let title: String
    let description: String
    let iconName: String
    let action: () -> Void
  }

  private lazy var demoItems: [DemoItem] = [
    DemoItem(
      title: "Basic Split View",
      description: "Simple primary, secondary, and inspector view configuration (iOS 26+)",
      iconName: "rectangle.split.2x1",
      action: { [weak self] in self?.basicDemoTapped() }
    ),
    DemoItem(
      title: "List-Detail Pattern",
      description: "Classic iOS navigation pattern with list and detail views",
      iconName: "sidebar.left",
      action: { [weak self] in self?.listDetailTapped() }
    ),
  ]

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: animated)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "Split View Demo"

    view.addSubview(tableView)

    // Layout constraints
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func basicDemoTapped() {
    let primaryVC = BasicPrimaryViewController()
    let secondaryVC = BasicSecondaryViewController()

    let splitViewController = NavigableSplitViewController(
      primary: primaryVC,
      secondary: secondaryVC
    )

    // Add inspector view on iOS 26+ using the public splitVC property
    if #available(iOS 26.0, *) {
      let inspectorVC = BasicInspectorViewController()
      splitViewController.splitVC.setViewController(inspectorVC, for: .inspector)
      splitViewController.splitVC.show(.inspector)
    }

    navigationController?.pushViewController(splitViewController, animated: true)
  }

  private func listDetailTapped() {
    let listVC = ListViewController()
    let detailVC = DetailTableViewController(style: .insetGrouped)

    let splitViewController = NavigableSplitViewController(
      primary: listVC,
      secondary: detailVC
    )

    navigationController?.pushViewController(splitViewController, animated: true)
  }
}

// MARK: - UITableViewDataSource
extension SplitViewDemoViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 0  // Header section with no rows
    }
    return demoItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
      as! DemoTableViewCell
    let demoItem = demoItems[indexPath.row]
    cell.configure(with: demoItem)
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "NavigableSplitView Demos"
    }
    return "Demo Options"
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    if section == 0 {
      return "Explore different configurations and use cases of the NavigableSplitView component."
    }
    return nil
  }
}

// MARK: - UITableViewDelegate
extension SplitViewDemoViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard navigationController?.topViewController == self else { return }
    let demoItem = demoItems[indexPath.row]
    demoItem.action()
  }
}

// MARK: - Custom Table View Cell
class DemoTableViewCell: UITableViewCell {

  private let iconImageView = UIImageView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let mainStackView = UIStackView()
  private let textStackView = UIStackView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupCell() {
    accessoryType = .disclosureIndicator

    // Configure icon
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.tintColor = .systemBlue
    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(grid(8))
    }

    // Configure title label
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.textColor = .label
    titleLabel.numberOfLines = 1

    // Configure description label
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.numberOfLines = 0

    // Configure text stack view
    textStackView.axis = .vertical
    textStackView.spacing = grid(1)
    textStackView.alignment = .leading
    textStackView.addArrangedSubview(titleLabel)
    textStackView.addArrangedSubview(descriptionLabel)

    // Configure main stack view
    mainStackView.axis = .horizontal
    mainStackView.spacing = grid(4)
    mainStackView.alignment = .center
    mainStackView.addArrangedSubview(iconImageView)
    mainStackView.addArrangedSubview(textStackView)

    contentView.addSubview(mainStackView)

    // Layout constraints
    mainStackView.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(contentView.layoutMarginsGuide)
      make.verticalEdges.equalTo(contentView).inset(grid(3))
    }
  }

  func configure(with demoItem: SplitViewDemoViewController.DemoItem) {
    iconImageView.image = UIImage(systemName: demoItem.iconName)
    titleLabel.text = demoItem.title
    descriptionLabel.text = demoItem.description
  }
}
