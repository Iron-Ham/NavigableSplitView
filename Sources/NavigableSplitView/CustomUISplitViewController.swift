#if canImport(UIKit)
import UIKit
#endif

class CustomUISplitViewController: UISplitViewController {
  override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
    let handled = delegate?.splitViewController?(self, showDetail: vc, sender: sender) ?? false

    if !handled {
      super.showDetailViewController(vc, sender: sender)
    }
  }
}
