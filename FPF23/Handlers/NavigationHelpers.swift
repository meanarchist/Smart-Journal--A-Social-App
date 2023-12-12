import UIKit

struct NavigationHelpers {

    static func navigateToCheckIn(from viewController: UIViewController) {
        if let checkInViewController = UIStoryboard(name: "CheckIn", bundle: nil)
            .instantiateViewController(withIdentifier: "checkIn") as? CheckInViewController {
            
            // Use either push or present, based on your app's navigation structure
            viewController.navigationController?.pushViewController(checkInViewController, animated: true)

            // viewController.present(checkInViewController, animated: true, completion: nil)
        }
    }
}
