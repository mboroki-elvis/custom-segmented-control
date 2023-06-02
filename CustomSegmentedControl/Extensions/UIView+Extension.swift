import UIKit

public extension UIView {
    func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 8.0, borderWidth: CGFloat = 1.5) {
        layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    // box-shadow: 0px 1px 5px 0px #0000004D;
    func addShadow(width: CGFloat = 0.0, height: CGFloat = 1.0, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
