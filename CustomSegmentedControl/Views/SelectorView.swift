import UIKit

public final class SelectorView: UIView {
    private let label: UILabel = .init()
    private let gradientLayer = CAGradientLayer()
    private var cornerRadius: CGFloat = 4
    private var gradientColors = [UIColor.hex(hex: "#009677").cgColor, UIColor.hex(hex: "60B848").cgColor]
    
    public override  init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = cornerRadius
        layer.addSublayer(gradientLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius
    }
}
