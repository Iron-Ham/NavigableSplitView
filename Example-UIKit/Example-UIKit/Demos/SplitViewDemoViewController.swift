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

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "Split View Demo"

    let scrollView = UIScrollView()
    view.addSubview(scrollView)

    // Main content stack view
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = grid(4)
    mainStackView.alignment = .fill
    scrollView.addSubview(mainStackView)

    // Header section
    let headerStackView = UIStackView()
    headerStackView.axis = .vertical
    headerStackView.spacing = grid(4)
    headerStackView.alignment = .fill

    let headerLabel = UILabel()
    headerLabel.text = "NavigableSplitView Demos"
    headerLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    headerLabel.textAlignment = .center

    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "Explore different configurations and use cases of the NavigableSplitView component."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0

    headerStackView.addArrangedSubview(headerLabel)
    headerStackView.addArrangedSubview(descriptionLabel)

    // Demo buttons stack view
    let buttonsStackView = UIStackView()
    buttonsStackView.axis = .vertical
    buttonsStackView.spacing = grid(4)
    buttonsStackView.alignment = .fill

    let basicDemoButton = createDemoButton(
      title: "Basic Split View",
      description: "Simple primary and secondary view configuration",
      iconName: "rectangle.split.2x1",
      action: #selector(basicDemoTapped)
    )

    let listDetailButton = createDemoButton(
      title: "List-Detail Pattern",
      description: "Classic iOS navigation pattern with list and detail views",
      iconName: "sidebar.left",
      action: #selector(listDetailTapped)
    )

    let customLayoutButton = createDemoButton(
      title: "Custom Layout Options",
      description: "Explore different display modes and split behaviors",
      iconName: "rectangle.split.3x1",
      action: #selector(customLayoutTapped)
    )

    let adaptiveButton = createDemoButton(
      title: "Adaptive Design",
      description: "See how the split view adapts to different screen sizes",
      iconName: "ipad.landscape.and.iphone",
      action: #selector(adaptiveTapped)
    )

    [basicDemoButton, listDetailButton, customLayoutButton, adaptiveButton].forEach {
      buttonsStackView.addArrangedSubview($0)
    }

    // Add header spacer
    let headerSpacer = UIView()
    headerSpacer.snp.makeConstraints { make in
      make.height.equalTo(grid(3))
    }

    mainStackView.addArrangedSubview(headerStackView)
    mainStackView.addArrangedSubview(headerSpacer)
    mainStackView.addArrangedSubview(buttonsStackView)

    // Layout constraints
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.bottom.equalTo(view)
    }

    mainStackView.snp.makeConstraints { make in
      make.top.equalTo(scrollView).offset(grid(5))
      make.leading.trailing.equalTo(view.readableContentGuide)
      make.bottom.equalTo(scrollView).offset(-grid(8))
      make.width.equalTo(view.readableContentGuide)
    }
  }

  private func createDemoButton(
    title: String, description: String, iconName: String, action: Selector
  ) -> UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = .systemBackground
    button.layer.cornerRadius = grid(3)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.systemGray4.cgColor

    // Main horizontal stack view
    let mainStackView = UIStackView()
    mainStackView.axis = .horizontal
    mainStackView.spacing = grid(4)
    mainStackView.alignment = .center
    mainStackView.isUserInteractionEnabled = false
    button.addSubview(mainStackView)

    // Icon
    let iconImageView = UIImageView()
    iconImageView.image = UIImage(systemName: iconName)
    iconImageView.tintColor = .systemBlue
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(grid(8))
    }

    // Text content stack view
    let textStackView = UIStackView()
    textStackView.axis = .vertical
    textStackView.spacing = grid(1)
    textStackView.alignment = .leading

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.textColor = .label

    let descriptionLabel = UILabel()
    descriptionLabel.text = description
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.numberOfLines = 0

    textStackView.addArrangedSubview(titleLabel)
    textStackView.addArrangedSubview(descriptionLabel)

    // Chevron
    let chevronImageView = UIImageView()
    chevronImageView.image = UIImage(systemName: "chevron.right")
    chevronImageView.tintColor = .systemGray3
    chevronImageView.contentMode = .scaleAspectFit
    chevronImageView.snp.makeConstraints { make in
      make.width.equalTo(grid(3))
      make.height.equalTo(grid(5))
    }

    mainStackView.addArrangedSubview(iconImageView)
    mainStackView.addArrangedSubview(textStackView)
    mainStackView.addArrangedSubview(chevronImageView)

    // Layout constraints
    button.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(grid(20))
    }

    mainStackView.snp.makeConstraints { make in
      make.leading.equalTo(button).offset(grid(4))
      make.trailing.equalTo(button).offset(-grid(4))
      make.top.equalTo(button).offset(grid(4))
      make.bottom.equalTo(button).offset(-grid(4))
    }

    button.addTarget(self, action: action, for: .touchUpInside)

    return button
  }

  @objc private func basicDemoTapped() {
    let primaryVC = BasicPrimaryViewController()
    let secondaryVC = BasicSecondaryViewController()

    let splitViewController = NavigableSplitViewController(
      primary: primaryVC,
      secondary: secondaryVC
    )

    navigationController?.pushViewController(splitViewController, animated: true)
  }

  @objc private func listDetailTapped() {
    let listVC = ListViewController()
    let detailVC = DetailTableViewController(style: .insetGrouped)

    let splitViewController = NavigableSplitViewController(
      primary: listVC,
      secondary: detailVC
    )

    navigationController?.pushViewController(splitViewController, animated: true)
  }

  @objc private func customLayoutTapped() {
    let customPrimaryVC = CustomPrimaryViewController()
    let customSecondaryVC = CustomSecondaryViewController()

    let splitViewController = NavigableSplitViewController(
      primary: customPrimaryVC,
      secondary: customSecondaryVC
    )

    navigationController?.pushViewController(splitViewController, animated: true)
  }

  @objc private func adaptiveTapped() {
    let adaptivePrimaryVC = AdaptivePrimaryViewController()
    let adaptiveSecondaryVC = AdaptiveSecondaryViewController()

    let splitViewController = NavigableSplitViewController(
      primary: adaptivePrimaryVC,
      secondary: adaptiveSecondaryVC
    )

    navigationController?.pushViewController(splitViewController, animated: true)
  }
}
