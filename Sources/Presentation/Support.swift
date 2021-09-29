#if os(iOS)

import UIKit

internal extension UIView {

    var owningController: UIViewController? {
        if let responder = self.next as? UIViewController {
            return responder
        } else if let responder = self.next as? UIView {
            return responder.owningController
        } else {
            return nil
        }
    }
}

#endif
