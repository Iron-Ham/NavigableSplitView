import UIKit

class CustomUISplitViewController: UISplitViewController {

  weak var navigableSplitViewController: NavigableSplitViewController?

  override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
    // Check if the NavigableSplitViewController is ready for operations
    if let navigableSplitVC = navigableSplitViewController,
      !navigableSplitVC.isReadyForSplitViewOperations
    {
      // Defer the operation until after viewDidAppear
      navigableSplitVC.deferredOperations.append {
        self.showDetailViewController(vc, sender: sender)
      }
      return
    }

    let handled = delegate?.splitViewController?(self, showDetail: vc, sender: sender) ?? false

    if !handled {
      super.showDetailViewController(vc, sender: sender)
    }
  }
}
