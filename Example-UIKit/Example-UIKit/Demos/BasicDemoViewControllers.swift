import NavigableSplitView
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

    let stack = UIStackView(arrangedSubviews: [label, descriptionLabel])
    stack.spacing = grid(4)
    stack.axis = .vertical

    view.addSubview(stack)
    stack.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view.readableContentGuide)
      make.centerY.equalToSuperview()
    }
  }
}

extension BasicPrimaryViewController: SplitViewControllerColumnProviding {
  var preferredCompactColumn: UISplitViewController.Column { .secondary }
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

    let stack = UIStackView(arrangedSubviews: [label, descriptionLabel])
    stack.spacing = grid(4)
    stack.axis = .vertical

    view.addSubview(stack)
    stack.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view.readableContentGuide)
      make.centerY.equalToSuperview()
    }
  }
}

class BasicInspectorViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemGray6
    title = "Inspector"

    let label = UILabel()
    label.text = "Inspector View"
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "The inspector view provides additional tools and information. This is available on iOS 26+ and appears as a third column in supported layouts."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    // Create a sample property list
    let propertyStackView = UIStackView()
    propertyStackView.axis = .vertical
    propertyStackView.spacing = 12
    propertyStackView.alignment = .fill
    propertyStackView.translatesAutoresizingMaskIntoConstraints = false

    let properties = [
      ("Display Mode", "On Beside Secondary"),
      ("Split Behavior", "Tile"),
      ("Primary Width", "320 pts"),
      ("Inspector Width", "280 pts"),
      ("Orientation", "Portrait"),
    ]

    for (title, value) in properties {
      let propertyView = createPropertyView(title: title, value: value)
      propertyStackView.addArrangedSubview(propertyView)
    }

    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false

    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(scrollView)
    scrollView.addSubview(contentView)

    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }

    contentView.snp.makeConstraints { make in
      make.edges.equalTo(scrollView)
      make.width.equalTo(scrollView)
    }

    let stack = UIStackView(arrangedSubviews: [label, descriptionLabel, propertyStackView])
    stack.spacing = grid(4)
    stack.axis = .vertical

    contentView.addSubview(stack)
    stack.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view.readableContentGuide)
      make.verticalEdges.equalToSuperview().inset(grid(4))
    }
  }

  private func createPropertyView(title: String, value: String) -> UIView {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    titleLabel.textColor = .label
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    let valueLabel = UILabel()
    valueLabel.text = value
    valueLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    valueLabel.textColor = .secondaryLabel
    valueLabel.translatesAutoresizingMaskIntoConstraints = false

    let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    stack.spacing = grid(4)
    stack.axis = .vertical

    return stack
  }
}
