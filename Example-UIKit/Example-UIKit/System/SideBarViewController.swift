//
//  SideBarViewController.swift
//  Example-UIKit
//
//  Created by Patrick Dinger on 7/15/25.
//

import UIKit

class SideBarViewController: UIViewController, UICollectionViewDelegate {
    
    private var _splitViewController: UISplitViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplitViewController()
    }
    
    private func setupSplitViewController() {
        // Create the split view controller
        _splitViewController = UISplitViewController(style: .doubleColumn)
        
        // Configure split view controller
        _splitViewController.preferredDisplayMode = .oneBesideSecondary
        _splitViewController.preferredSplitBehavior = .tile
        
        // Create primary (sidebar) view controller
        let primaryVC = createPrimaryViewController()
        
        // Create secondary (detail) view controller - you can replace this with your actual detail view
        let secondaryVC = createSecondaryViewController()
        
        // Set the view controllers
        _splitViewController.setViewController(primaryVC, for: .primary)
        _splitViewController.setViewController(secondaryVC, for: .secondary)
        
        // Add split view controller as child
        addChild(_splitViewController)
        view.addSubview(_splitViewController.view)
        _splitViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _splitViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _splitViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _splitViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _splitViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        _splitViewController.didMove(toParent: self)
    }

    private func createPrimaryViewController() -> UIViewController {
        // Create the actual sidebar with collection view
        let sidebarVC = SidebarContentViewController()
        sidebarVC.delegate = self
        return sidebarVC
    }
    
    private func createSecondaryViewController() -> UIViewController {
        // Create the detail view controller
        let detailVC = UIViewController()
        detailVC.view.backgroundColor = .secondarySystemBackground
        detailVC.title = "Select an item"
        
        let label = UILabel()
        label.text = "Select an item from the sidebar"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        detailVC.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: detailVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: detailVC.view.centerYAnchor)
        ])
        
        return UINavigationController(rootViewController: detailVC)
    }
}

// MARK: - Sidebar Content
protocol SidebarContentDelegate: AnyObject {
    func didSelectSidebarItem(_ item: SidebarItem)
}

enum SidebarItem: String, CaseIterable {
    case home = "Home"
    case splitViewDemo = "Split View Demo"
}

class SidebarContentViewController: UIViewController, UICollectionViewDelegate {
    weak var delegate: SidebarContentDelegate?
    var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, SidebarItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Menu"
        configureHierarchy()
        configureDataSource()
    }

    public func selectDemo() {
        delegate?.didSelectSidebarItem(.splitViewDemo)
    }

    private func configureHierarchy() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
            config.showsSeparators = false
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
        }

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.rawValue
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource<Int, SidebarItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SidebarItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, SidebarItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(SidebarItem.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = SidebarItem.allCases[indexPath.item]
        delegate?.didSelectSidebarItem(selectedItem)
    }
}

// MARK: - Sidebar Delegate
extension SideBarViewController: SidebarContentDelegate {
    func didSelectSidebarItem(_ item: SidebarItem) {
        // Handle navigation based on selected item
        let detailVC: UIViewController
        
        switch item {
        case .home:
            detailVC = UINavigationController(rootViewController: HomeViewController())
        case .splitViewDemo:
            detailVC = UINavigationController(rootViewController: SplitViewDemoViewController())
        }

        _splitViewController.setViewController(detailVC, for: .secondary)
    }
    
    private func createDetailViewController(title: String, message: String) -> UIViewController {
        let detailVC = UIViewController()
        detailVC.view.backgroundColor = .secondarySystemBackground
        detailVC.title = title
        
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        detailVC.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: detailVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: detailVC.view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: detailVC.view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: detailVC.view.trailingAnchor, constant: -20)
        ])
        
        return detailVC
    }
}
