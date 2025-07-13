//
//  AboutViewController.swift
//  Example-UIKit
//
//  Created by Hesham Salman on 7/11/25.
//

import SnapKit
import UIKit

class AboutViewController: UIViewController {

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.cellLayoutMarginsFollowReadableWidth = true
    tableView.separatorStyle = .none
    tableView.register(AboutHeaderCell.self, forCellReuseIdentifier: "AboutHeaderCell")
    tableView.register(AboutDescriptionCell.self, forCellReuseIdentifier: "AboutDescriptionCell")
    tableView.register(AboutFeatureCell.self, forCellReuseIdentifier: "AboutFeatureCell")
    tableView.register(AboutDeveloperCell.self, forCellReuseIdentifier: "AboutDeveloperCell")
    tableView.register(AboutLinkCell.self, forCellReuseIdentifier: "AboutLinkCell")
    return tableView
  }()

  private let sections: [AboutSection] = [
    .header,
    .description,
    .features([
      ("checkmark.circle.fill", "Seamless Navigation Integration"),
      ("arrow.left.circle.fill", "Automatic Back Button Handling"),
      ("ipad.landscape.and.iphone", "Adaptive Layout Support"),
      ("gear", "Customizable Display Options"),
      ("swift", "Pure UIKit Implementation"),
    ]),
    .developer,
    .links([
      ("GitHub Repository", "link.circle.fill", "https://github.com/Iron-Ham/NavigableSplitView/"),
      ("Documentation", "book.circle.fill", "https://docs.example.com/navigablesplitview"),
      ("API Reference", "doc.text.fill", "https://api.example.com/navigablesplitview"),
      (
        "Swift Package Manager", "shippingbox.fill",
        "https://swiftpackageindex.com/example/navigablesplitview"
      ),
    ]),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemGroupedBackground
    title = "About"

    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }

  }
}

// MARK: - About Section Enum

enum AboutSection {
  case header
  case description
  case features([(String, String)])  // (iconName, text)
  case developer
  case links([(String, String, String)])  // (title, iconName, url)

  var title: String? {
    switch self {
    case .features: return "Key Features"
    case .developer: return "Developer"
    case .links: return "Links"
    default: return nil
    }
  }
}

// MARK: - UITableView DataSource & Delegate

extension AboutViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let aboutSection = sections[section]
    switch aboutSection {
    case .features(let features):
      return features.count
    case .links(let links):
      return links.count
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let aboutSection = sections[indexPath.section]

    switch aboutSection {
    case .header:
      let cell =
        tableView.dequeueReusableCell(withIdentifier: "AboutHeaderCell", for: indexPath)
        as! AboutHeaderCell
      return cell

    case .description:
      let cell =
        tableView.dequeueReusableCell(withIdentifier: "AboutDescriptionCell", for: indexPath)
        as! AboutDescriptionCell
      return cell

    case .features(let features):
      let cell =
        tableView.dequeueReusableCell(withIdentifier: "AboutFeatureCell", for: indexPath)
        as! AboutFeatureCell
      let feature = features[indexPath.row]
      cell.configure(iconName: feature.0, text: feature.1)
      return cell

    case .developer:
      let cell =
        tableView.dequeueReusableCell(withIdentifier: "AboutDeveloperCell", for: indexPath)
        as! AboutDeveloperCell
      return cell

    case .links(let links):
      let cell =
        tableView.dequeueReusableCell(withIdentifier: "AboutLinkCell", for: indexPath)
        as! AboutLinkCell
      let link = links[indexPath.row]
      cell.configure(title: link.0, iconName: link.1, url: link.2)
      cell.delegate = self
      return cell
    }
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return sections[section].title != nil ? UITableView.automaticDimension : 0
  }
}

// MARK: - AboutLinkCell Delegate

protocol AboutLinkCellDelegate: AnyObject {
  func aboutLinkCell(_ cell: AboutLinkCell, didTapLinkWithURL url: String)
}

extension AboutViewController: AboutLinkCellDelegate {
  func aboutLinkCell(_ cell: AboutLinkCell, didTapLinkWithURL url: String) {
    guard let url = URL(string: url) else { return }
    UIApplication.shared.open(url)
  }
}

// MARK: - Table View Cells

class AboutHeaderCell: UITableViewCell {

  private let containerStackView = UIStackView()
  private let appIconImageView = UIImageView()
  private let appNameLabel = UILabel()
  private let versionLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    selectionStyle = .none
    backgroundColor = .secondarySystemGroupedBackground

    // Configure stack view
    containerStackView.axis = .vertical
    containerStackView.spacing = grid(4)
    containerStackView.alignment = .center

    // Configure app icon with gradient background
    appIconImageView.image = UIImage(systemName: "rectangle.split.2x1.fill")
    appIconImageView.tintColor = .white
    appIconImageView.contentMode = .scaleAspectFit
    appIconImageView.backgroundColor = .systemBlue
    appIconImageView.layer.cornerRadius = 20
    appIconImageView.layer.masksToBounds = true

    // Configure labels
    appNameLabel.text = "NavigableSplitView"
    appNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    appNameLabel.textAlignment = .center
    appNameLabel.textColor = .label

    versionLabel.text = "Version 1.0.0"
    versionLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    versionLabel.textColor = .secondaryLabel
    versionLabel.textAlignment = .center

    // Add to stack view
    containerStackView.addArrangedSubview(appIconImageView)
    containerStackView.addArrangedSubview(appNameLabel)
    containerStackView.addArrangedSubview(versionLabel)

    contentView.addSubview(containerStackView)

    // Constraints
    appIconImageView.snp.makeConstraints { make in
      make.size.equalTo(80)
    }

    containerStackView.snp.makeConstraints { make in
      make.edges.equalTo(contentView.layoutMarginsGuide).inset(grid(4))
    }
  }
}

class AboutDescriptionCell: UITableViewCell {

  private let descriptionLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    selectionStyle = .none
    backgroundColor = .secondarySystemGroupedBackground

    descriptionLabel.text =
      "A powerful UIKit component that enables seamless integration of split view controllers into navigation hierarchies. Push split views onto navigation stacks just like any other view controller."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .label
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0

    contentView.addSubview(descriptionLabel)

    descriptionLabel.snp.makeConstraints { make in
      make.edges.equalTo(contentView.layoutMarginsGuide).inset(grid(4))
    }
  }
}

class AboutFeatureCell: UITableViewCell {

  private let containerStackView = UIStackView()
  private let iconImageView = UIImageView()
  private let informationLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    selectionStyle = .none
    backgroundColor = .secondarySystemGroupedBackground

    // Configure stack view
    containerStackView.axis = .horizontal
    containerStackView.spacing = grid(3)
    containerStackView.alignment = .center

    // Configure icon
    iconImageView.tintColor = .systemGreen
    iconImageView.contentMode = .scaleAspectFit

    // Configure text label
    informationLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    informationLabel.textColor = .label

    // Add to stack view
    containerStackView.addArrangedSubview(iconImageView)
    containerStackView.addArrangedSubview(informationLabel)

    contentView.addSubview(containerStackView)

    // Constraints
    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(20)
    }

    containerStackView.snp.makeConstraints { make in
      make.edges.equalTo(contentView.layoutMarginsGuide).inset(
        UIEdgeInsets(top: grid(2), left: 0, bottom: grid(2), right: 0))
    }
  }

  func configure(iconName: String, text: String) {
    iconImageView.image = UIImage(systemName: iconName)
    informationLabel.text = text
  }
}

class AboutDeveloperCell: UITableViewCell {

  private let containerStackView = UIStackView()
  private let profileImageView = UIImageView()
  private let textStackView = UIStackView()
  private let nameLabel = UILabel()
  private let roleLabel = UILabel()
  private let usernameLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    loadProfileImage()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    selectionStyle = .none
    backgroundColor = .secondarySystemGroupedBackground

    // Configure profile image
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.layer.cornerRadius = 30
    profileImageView.layer.masksToBounds = true
    profileImageView.backgroundColor = .systemGray5

    // Configure main stack view
    containerStackView.axis = .horizontal
    containerStackView.spacing = grid(4)
    containerStackView.alignment = .center

    // Configure text stack view
    textStackView.axis = .vertical
    textStackView.spacing = grid(1)
    textStackView.alignment = .leading

    // Configure labels
    nameLabel.text = "Hesham Salman"
    nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    nameLabel.textColor = .label

    roleLabel.text = "iOS Developer"
    roleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    roleLabel.textColor = .secondaryLabel

    usernameLabel.text = "@iron-ham"
    usernameLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    usernameLabel.textColor = .systemBlue

    // Add to text stack view
    textStackView.addArrangedSubview(nameLabel)
    textStackView.addArrangedSubview(roleLabel)
    textStackView.addArrangedSubview(usernameLabel)

    // Add to main stack view
    containerStackView.addArrangedSubview(profileImageView)
    containerStackView.addArrangedSubview(textStackView)

    // Add to content view
    contentView.addSubview(containerStackView)

    // Constraints
    profileImageView.snp.makeConstraints { make in
      make.size.equalTo(60)
    }

    containerStackView.snp.makeConstraints { make in
      make.edges.equalTo(contentView.layoutMarginsGuide).inset(grid(4))
    }
  }

  private func loadProfileImage() {
    guard let url = URL(string: "https://github.com/iron-ham.png") else { return }

    // Create a placeholder image
    let placeholderImage = UIImage(systemName: "person.circle.fill")?.withRenderingMode(
      .alwaysTemplate)
    profileImageView.image = placeholderImage
    profileImageView.tintColor = .systemGray3

    // Load the image asynchronously
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let data = data, error == nil, let image = UIImage(data: data) else {
        return
      }

      DispatchQueue.main.async {
        self?.profileImageView.image = image
      }
    }.resume()
  }
}

class AboutLinkCell: UITableViewCell {

  weak var delegate: AboutLinkCellDelegate?
  private var url: String = ""

  private let containerStackView = UIStackView()
  private let iconImageView = UIImageView()
  private let titleLabel = UILabel()
  private let chevronImageView = UIImageView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    selectionStyle = .default
    backgroundColor = .secondarySystemGroupedBackground

    // Configure stack view
    containerStackView.axis = .horizontal
    containerStackView.spacing = grid(3)
    containerStackView.alignment = .center

    // Configure icon
    iconImageView.tintColor = .systemBlue
    iconImageView.contentMode = .scaleAspectFit

    // Configure title label
    titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    titleLabel.textColor = .label

    // Configure chevron
    chevronImageView.image = UIImage(systemName: "chevron.right")
    chevronImageView.tintColor = .tertiaryLabel
    chevronImageView.contentMode = .scaleAspectFit

    // Add to stack view
    containerStackView.addArrangedSubview(iconImageView)
    containerStackView.addArrangedSubview(titleLabel)
    containerStackView.addArrangedSubview(chevronImageView)

    contentView.addSubview(containerStackView)

    // Constraints
    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(20)
    }

    chevronImageView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 8, height: 12))
    }

    containerStackView.snp.makeConstraints { make in
      make.edges.equalTo(contentView.layoutMarginsGuide)
    }

    // Add tap gesture
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    addGestureRecognizer(tapGesture)
  }

  func configure(title: String, iconName: String, url: String) {
    titleLabel.text = title
    iconImageView.image = UIImage(systemName: iconName)
    self.url = url
  }

  @objc private func cellTapped() {
    delegate?.aboutLinkCell(self, didTapLinkWithURL: url)
  }
}
