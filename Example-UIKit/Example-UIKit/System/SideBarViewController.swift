import NavigableSplitView
import UIKit

enum SidebarItem: String, CaseIterable {
  case home = "Home"
  case splitViewDemo = "Split View Demo"
}

class SidebarContentViewController: UIViewController, UICollectionViewDelegate {
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
      var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
      config.showsSeparators = false
      return NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
    }
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collectionView.delegate = self
    return collectionView
  }()
  private var dataSource: UICollectionViewDiffableDataSource<Int, SidebarItem>!

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Menu"
    view.addSubview(collectionView)
    configureDataSource()
  }

  private func configureDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem>
    {
      (cell, indexPath, item) in
      var content = cell.defaultContentConfiguration()
      content.text = item.rawValue
      cell.contentConfiguration = content
    }

    dataSource = UICollectionViewDiffableDataSource<Int, SidebarItem>(
      collectionView: collectionView
    ) {
      (collectionView: UICollectionView, indexPath: IndexPath, identifier: SidebarItem)
        -> UICollectionViewCell? in
      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration, for: indexPath, item: identifier)
    }

    var snapshot = NSDiffableDataSourceSnapshot<Int, SidebarItem>()
    snapshot.appendSections([0])
    snapshot.appendItems(SidebarItem.allCases)
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedItem = SidebarItem.allCases[indexPath.item]
    let detailVC: UIViewController

    switch selectedItem {
    case .home:
      detailVC = HomeViewController()
    case .splitViewDemo:
      detailVC = SplitViewDemoViewController()
    }

    splitViewController?.showDetailViewController(detailVC, sender: nil)
  }

  func selectDemo() {
    splitViewController?.showDetailViewController(SplitViewDemoViewController(), sender: nil)
  }
}

extension SidebarContentViewController: SplitViewControllerColumnProviding {
  var preferredCompactColumn: UISplitViewController.Column {
    if collectionView.indexPathsForSelectedItems?.first != nil {
      UISplitViewController.Column.secondary
    } else {
      UISplitViewController.Column.primary
    }
  }
}
