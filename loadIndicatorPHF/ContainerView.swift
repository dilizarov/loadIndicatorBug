import UIKit

class ContainerView: UIView {
    
    var customInputView: UIView!
    
    override var inputAccessoryView: UIView {
        return self.customInputView
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
}