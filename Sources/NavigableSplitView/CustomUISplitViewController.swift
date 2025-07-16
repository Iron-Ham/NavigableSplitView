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
      // While iOS 16-18 produce a warning in the logs that this call does nothing in `DoubleColumn`
      // style `UISplitView`, neglecting to call this will never show a view in the detail column.
      //
      // Notably, iOS 26 does not produce such a warning – and the documentation clearly states that
      // this function *must* be implemented for all container views, which includes
      // `UISplitViewController`.
      super.showDetailViewController(vc, sender: sender)
    }
  }
}
