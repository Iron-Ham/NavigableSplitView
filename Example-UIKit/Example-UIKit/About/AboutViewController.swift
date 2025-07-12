//
//  AboutViewController.swift
//  Example-UIKit
//
//  Created by Hesham Salman on 7/11/25.
//

import SnapKit
import UIKit

class AboutViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "About"

    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)

    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentView)

    // App Icon and Title
    let appIconImageView = UIImageView()
    appIconImageView.image = UIImage(systemName: "rectangle.split.2x1.fill")
    appIconImageView.tintColor = .systemBlue
    appIconImageView.contentMode = .scaleAspectFit
    appIconImageView.translatesAutoresizingMaskIntoConstraints = false

    let appNameLabel = UILabel()
    appNameLabel.text = "NavigableSplitView"
    appNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    appNameLabel.textAlignment = .center
    appNameLabel.translatesAutoresizingMaskIntoConstraints = false

    let versionLabel = UILabel()
    versionLabel.text = "Version 1.0.0"
    versionLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    versionLabel.textColor = .secondaryLabel
    versionLabel.textAlignment = .center
    versionLabel.translatesAutoresizingMaskIntoConstraints = false

    // Description
    let descriptionLabel = UILabel()
    descriptionLabel.text =
      "A powerful UIKit component that enables seamless integration of split view controllers into navigation hierarchies. Push split views onto navigation stacks just like any other view controller."
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .label
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    // Features Section
    let featuresHeaderLabel = UILabel()
    featuresHeaderLabel.text = "Key Features"
    featuresHeaderLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    featuresHeaderLabel.translatesAutoresizingMaskIntoConstraints = false

    let featuresStackView = createFeaturesStackView()

    // Developer Section
    let developerHeaderLabel = UILabel()
    developerHeaderLabel.text = "Developer"
    developerHeaderLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    developerHeaderLabel.translatesAutoresizingMaskIntoConstraints = false

    let developerInfoView = createDeveloperInfoView()

    // Links Section
    let linksHeaderLabel = UILabel()
    linksHeaderLabel.text = "Links"
    linksHeaderLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    linksHeaderLabel.translatesAutoresizingMaskIntoConstraints = false

    let linksStackView = createLinksStackView()

    // Copyright
    let copyrightLabel = UILabel()
    copyrightLabel.text = "© 2025 NavigableSplitView. All rights reserved."
    copyrightLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    copyrightLabel.textColor = .tertiaryLabel
    copyrightLabel.textAlignment = .center
    copyrightLabel.translatesAutoresizingMaskIntoConstraints = false

    // Add all views
    [
      appIconImageView, appNameLabel, versionLabel, descriptionLabel,
      featuresHeaderLabel, featuresStackView, developerHeaderLabel, developerInfoView,
      linksHeaderLabel, linksStackView, copyrightLabel,
    ].forEach {
      contentView.addSubview($0)
    }

    // Layout constraints
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      appIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
      appIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      appIconImageView.widthAnchor.constraint(equalToConstant: 80),
      appIconImageView.heightAnchor.constraint(equalToConstant: 80),

      appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 16),
      appNameLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      appNameLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

      versionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 4),
      versionLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      versionLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

      descriptionLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 24),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

      featuresHeaderLabel.topAnchor.constraint(
        equalTo: descriptionLabel.bottomAnchor, constant: 40),
      featuresHeaderLabel.leadingAnchor.constraint(
        equalTo: view.readableContentGuide.leadingAnchor),

      featuresStackView.topAnchor.constraint(
        equalTo: featuresHeaderLabel.bottomAnchor, constant: 16),
      featuresStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      featuresStackView.trailingAnchor.constraint(
        equalTo: view.readableContentGuide.trailingAnchor),

      developerHeaderLabel.topAnchor.constraint(
        equalTo: featuresStackView.bottomAnchor, constant: 40),
      developerHeaderLabel.leadingAnchor.constraint(
        equalTo: view.readableContentGuide.leadingAnchor),

      developerInfoView.topAnchor.constraint(
        equalTo: developerHeaderLabel.bottomAnchor, constant: 16),
      developerInfoView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      developerInfoView.trailingAnchor.constraint(
        equalTo: view.readableContentGuide.trailingAnchor),

      linksHeaderLabel.topAnchor.constraint(equalTo: developerInfoView.bottomAnchor, constant: 40),
      linksHeaderLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),

      linksStackView.topAnchor.constraint(equalTo: linksHeaderLabel.bottomAnchor, constant: 16),
      linksStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      linksStackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

      copyrightLabel.topAnchor.constraint(equalTo: linksStackView.bottomAnchor, constant: 40),
      copyrightLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      copyrightLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
      copyrightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
    ])
  }

  private func createFeaturesStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 12
    stackView.translatesAutoresizingMaskIntoConstraints = false

    let features = [
      ("checkmark.circle.fill", "Seamless Navigation Integration"),
      ("arrow.left.circle.fill", "Automatic Back Button Handling"),
      ("ipad.landscape.and.iphone", "Adaptive Layout Support"),
      ("gear", "Customizable Display Options"),
      ("swift", "Pure UIKit Implementation"),
    ]

    for (iconName, text) in features {
      let featureView = createFeatureView(iconName: iconName, text: text)
      stackView.addArrangedSubview(featureView)
    }

    return stackView
  }

  private func createFeatureView(iconName: String, text: String) -> UIView {
    let containerView = UIView()

    let iconImageView = UIImageView()
    iconImageView.image = UIImage(systemName: iconName)
    iconImageView.tintColor = .systemGreen
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.translatesAutoresizingMaskIntoConstraints = false

    let textLabel = UILabel()
    textLabel.text = text
    textLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    textLabel.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(iconImageView)
    containerView.addSubview(textLabel)

    NSLayoutConstraint.activate([
      iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 20),
      iconImageView.heightAnchor.constraint(equalToConstant: 20),

      textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
      textLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

      containerView.heightAnchor.constraint(equalToConstant: 24),
    ])

    return containerView
  }

  private func createDeveloperInfoView() -> UIView {
    let containerView = UIView()
    containerView.backgroundColor = .secondarySystemBackground
    containerView.layer.cornerRadius = 12
    containerView.translatesAutoresizingMaskIntoConstraints = false

    let nameLabel = UILabel()
    nameLabel.text = "Hesham Salman"
    nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false

    let roleLabel = UILabel()
    roleLabel.text = "iOS Developer"
    roleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    roleLabel.textColor = .secondaryLabel
    roleLabel.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(nameLabel)
    containerView.addSubview(roleLabel)

    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

      roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
      roleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      roleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      roleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
    ])

    return containerView
  }

  private func createLinksStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false

    let links = [
      ("GitHub Repository", "link.circle.fill", "https://github.com/example/navigablesplitview"),
      ("Documentation", "book.circle.fill", "https://docs.example.com/navigablesplitview"),
      ("API Reference", "doc.text.fill", "https://api.example.com/navigablesplitview"),
      (
        "Swift Package Manager", "shippingbox.fill",
        "https://swiftpackageindex.com/example/navigablesplitview"
      ),
    ]

    for (title, iconName, url) in links {
      let linkButton = createLinkButton(title: title, iconName: iconName, url: url)
      stackView.addArrangedSubview(linkButton)
    }

    return stackView
  }

  private func createLinkButton(title: String, iconName: String, url: String) -> UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = .tertiarySystemBackground
    button.layer.cornerRadius = 8
    button.contentHorizontalAlignment = .leading
    button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    button.translatesAutoresizingMaskIntoConstraints = false

    let iconImageView = UIImageView()
    iconImageView.image = UIImage(systemName: iconName)
    iconImageView.tintColor = .systemBlue
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.translatesAutoresizingMaskIntoConstraints = false

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    titleLabel.textColor = .systemBlue
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    button.addSubview(iconImageView)
    button.addSubview(titleLabel)

    NSLayoutConstraint.activate([
      button.heightAnchor.constraint(equalToConstant: 44),

      iconImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
      iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 20),
      iconImageView.heightAnchor.constraint(equalToConstant: 20),

      titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
      titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
    ])

    button.addTarget(self, action: #selector(linkButtonTapped(_:)), for: .touchUpInside)
    button.accessibilityIdentifier = url

    return button
  }

  @objc private func linkButtonTapped(_ sender: UIButton) {
    guard let urlString = sender.accessibilityIdentifier,
      let url = URL(string: urlString)
    else { return }

    UIApplication.shared.open(url)
  }
}
