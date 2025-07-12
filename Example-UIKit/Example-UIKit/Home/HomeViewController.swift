import SnapKit
import UIKit

class HomeViewController: UIViewController {
  
  private let tableView = UITableView(frame: .zero, style: .insetGrouped)
  
  private enum Section: Int, CaseIterable {
    case hero
    case features
    case getStarted
    
    var title: String? {
      switch self {
      case .hero:
        return nil
      case .features:
        return "Key Features"
      case .getStarted:
        return nil
      }
    }
  }
  
  private enum FeatureItem: Int, CaseIterable {
    case pushableSplitViews
    case automaticBackButton
    case adaptiveLayouts
    
    var icon: String {
      switch self {
      case .pushableSplitViews:
        return "arrow.turn.down.right"
      case .automaticBackButton:
        return "arrow.left"
      case .adaptiveLayouts:
        return "ipad.landscape.and.iphone"
      }
    }
    
    var title: String {
      switch self {
      case .pushableSplitViews:
        return "Pushable Split Views"
      case .automaticBackButton:
        return "Automatic Back Button"
      case .adaptiveLayouts:
        return "Adaptive Layouts"
      }
    }
    
    var description: String {
      switch self {
      case .pushableSplitViews:
        return "Push split view controllers onto navigation stacks like any other view controller"
      case .automaticBackButton:
        return "Seamless back button integration maintains consistent navigation behavior"
      case .adaptiveLayouts:
        return "Automatically adapts to different screen sizes and orientations"
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemGroupedBackground
    title = "Home"
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.cellLayoutMarginsFollowReadableWidth = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    // Register cell types
    tableView.register(HeroTableViewCell.self, forCellReuseIdentifier: "HeroCell")
    tableView.register(FeatureTableViewCell.self, forCellReuseIdentifier: "FeatureCell")
    tableView.register(GetStartedTableViewCell.self, forCellReuseIdentifier: "GetStartedCell")
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  @objc private func getStartedTapped() {
    // Switch to the Split View Demo tab
    if let tabBarController = tabBarController {
      tabBarController.selectedIndex = 1  // Split View Demo tab
    }
  }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Section.allCases.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sectionType = Section(rawValue: section) else { return 0 }
    
    switch sectionType {
    case .hero:
      return 1
    case .features:
      return FeatureItem.allCases.count
    case .getStarted:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let sectionType = Section(rawValue: indexPath.section) else {
      return UITableViewCell()
    }
    
    switch sectionType {
    case .hero:
      let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! HeroTableViewCell
      return cell
      
    case .features:
      let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as! FeatureTableViewCell
      let feature = FeatureItem.allCases[indexPath.row]
      cell.configure(icon: feature.icon, title: feature.title, description: feature.description)
      return cell
      
    case .getStarted:
      let cell = tableView.dequeueReusableCell(withIdentifier: "GetStartedCell", for: indexPath) as! GetStartedTableViewCell
      cell.onButtonTapped = { [weak self] in
        self?.getStartedTapped()
      }
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let sectionType = Section(rawValue: section) else { return nil }
    return sectionType.title
  }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    guard let sectionType = Section(rawValue: indexPath.section) else { return false }
    return sectionType == .getStarted
  }
}

// MARK: - Custom Table View Cells

class HeroTableViewCell: UITableViewCell {
  
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
    
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = grid(5)
    mainStackView.alignment = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    // Hero image
    let heroImageView = UIImageView()
    heroImageView.image = UIImage(systemName: "rectangle.split.2x1")
    heroImageView.tintColor = .systemBlue
    heroImageView.contentMode = .scaleAspectFit
    heroImageView.translatesAutoresizingMaskIntoConstraints = false
    
    // Text stack view
    let textStackView = UIStackView()
    textStackView.axis = .vertical
    textStackView.spacing = grid(2)
    textStackView.alignment = .fill
    
    let titleLabel = UILabel()
    titleLabel.text = "NavigableSplitView"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    
    let subtitleLabel = UILabel()
    subtitleLabel.text = "Seamless Split View Navigation"
    subtitleLabel.textAlignment = .center
    subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    subtitleLabel.textColor = .secondaryLabel
    
    let descriptionLabel = UILabel()
    descriptionLabel.text = "A powerful UIKit component that allows UISplitViewController to be pushed onto existing navigation hierarchies, enabling seamless integration of split view controllers into navigation stacks."
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.numberOfLines = 0
    
    textStackView.addArrangedSubview(titleLabel)
    textStackView.addArrangedSubview(subtitleLabel)
    
    // Add spacing before description
    let spacerView = UIView()
    spacerView.snp.makeConstraints { make in
      make.height.equalTo(grid(3))
    }
    textStackView.addArrangedSubview(spacerView)
    textStackView.addArrangedSubview(descriptionLabel)
    
    mainStackView.addArrangedSubview(heroImageView)
    mainStackView.addArrangedSubview(textStackView)
    
    contentView.addSubview(mainStackView)
    
    mainStackView.snp.makeConstraints { make in
      make.top.bottom.equalTo(contentView).inset(20)
      make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
    }
    
    heroImageView.snp.makeConstraints { make in
      make.height.equalTo(grid(20))
    }
  }
}

class FeatureTableViewCell: UITableViewCell {
  
  private let iconImageView = UIImageView()
  private let titleLabel = UILabel()
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
    backgroundColor = .clear
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = grid(3)
    stackView.alignment = .top
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    iconImageView.tintColor = .systemBlue
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let textStackView = UIStackView()
    textStackView.axis = .vertical
    textStackView.spacing = grid(1)
    textStackView.alignment = .fill
    
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.numberOfLines = 0
    
    textStackView.addArrangedSubview(titleLabel)
    textStackView.addArrangedSubview(descriptionLabel)
    
    stackView.addArrangedSubview(iconImageView)
    stackView.addArrangedSubview(textStackView)
    
    contentView.addSubview(stackView)
    
    stackView.snp.makeConstraints { make in
      make.top.bottom.equalTo(contentView).inset(grid(3))
      make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
    }
    
    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(grid(6))
    }
  }
  
  func configure(icon: String, title: String, description: String) {
    iconImageView.image = UIImage(systemName: icon)
    titleLabel.text = title
    descriptionLabel.text = description
  }
}

class GetStartedTableViewCell: UITableViewCell {
  
  var onButtonTapped: (() -> Void)?
  
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
    
    let button = UIButton(type: .system)
    button.setTitle("Try the Demo", for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = grid(3)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(button)
    
    button.snp.makeConstraints { make in
      make.center.equalTo(contentView)
      make.top.bottom.equalTo(contentView).inset(grid(5))
      make.height.equalTo(grid(12))
      make.width.equalTo(grid(50))
    }
  }
  
  @objc private func buttonTapped() {
    onButtonTapped?()
  }
}
