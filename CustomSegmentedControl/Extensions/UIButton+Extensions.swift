import UIKit

public extension UIButton {
    func setImage(_ image: UIImage?) {
        for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            setImage(image, for: state)
        }
    }
}
