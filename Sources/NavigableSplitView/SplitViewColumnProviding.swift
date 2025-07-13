import UIKit

public protocol SplitViewControllerColumnProviding: UIViewController {
  var preferredCompactColumn: UISplitViewController.Column { get }
}
