import Foundation
import UIKit

protocol Storyboardable: AnyObject {
    static var defaultStoryboardName: String { get }
}

extension Storyboardable where Self: UIViewController {
    static var defaultStoryboardName: String {
        return "Main"
    }

    static func fromStoryboard() -> Self {
        let stbd = UIStoryboard(name: defaultStoryboardName, bundle: nil)
        guard let viewC = stbd.instantiateViewController(withIdentifier: String(describing: self)) as? Self else {
            fatalError("Could not instantiate view controller")
        }
        return viewC
    }
}

extension UIViewController: Storyboardable {}
