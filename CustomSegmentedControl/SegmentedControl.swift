import UIKit

@IBDesignable
open class OMKSegmentedControl: UIControl {
    public var selectedSegmentIndex = 0
    
    var stackView: UIStackView!
    open var selector: SelectorView!
    open var segments = [UIButton]() {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            setCornerBorder(cornerRadius: cornerRadius)
        }
    }

    @IBInspectable open var spacing: CGFloat = 2.0 {
        didSet {
            updateViews()
        }
    }
    
    /**
     The foreground color of the segment.
     */
    @IBInspectable public var foregroundColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }

    /**
     The boolean to set whether the segment control displays the original color of the icon.
     */
    @IBInspectable public var preserveIconColor: Bool = false {
        didSet {
            updateViews()
        }
    }

    public enum SelectorStyle {
        case fill
        case outline
        case line
    }

    /**
      The selector UI type. See demo app for their looks.
     
      TODO: Will make it available in storyboard with @IBInspectable.
     */
    public var selectorStyle: SelectorStyle = .line {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable public var selectorColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable public var selectedForegroundColor: UIColor = .white {
        didSet {
            updateViews()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     Convenience initializer of MaterialSegmentedControl.
     
     - Parameter segments:        The segment in UIButton form.
     - Parameter selectorStyle:   The style of the selector, fill, outline and line are supported.
     - Parameter cornerRadius:    The corner radius of the segmented control. Used to crop rounded corner.
     - Parameter fgColor:         The foreground color of the non-selected segment.
     - Parameter selectedFgColor: The foreground color of the selected segment.
     - Parameter selectorColor:   The color of the selector.
     - Parameter bgColor:         Background color.
     */
    public convenience init(segments: [UIButton] = [], selectorStyle: SelectorStyle = .line, cornerRadius: CGFloat,
                            fgColor: UIColor, selectedFgColor: UIColor, selectorColor: UIColor, bgColor: UIColor)
    {
        self.init(frame: .zero)
        
        self.segments = segments
        self.selectorStyle = selectorStyle
        self.foregroundColor = fgColor
        self.selectedForegroundColor = selectedFgColor
        self.selectorColor = selectorColor
        self.backgroundColor = bgColor
        defer {
            self.cornerRadius = cornerRadius
        }
    }

    /**
     Convenience init of material design segmentedControl using system default colors. This initializer
     reflects dark mode colors on iOS 13 or later platforms. However, it will ignore any custom colors
     set to the segmentedControl.
     
     - Parameter segments:      The segment in UIButton form.
     - Parameter selectorStyle: The style of the selector, fill, outline and line are supported.
     - Parameter cornerRadius:  The corner radius of the segmented control. Used to crop rounded corner.
     */
    @available(iOS 13.0, *)
    public convenience init(segments: [UIButton] = [], selectorStyle: SelectorStyle = .line, cornerRadius: CGFloat) {
        self.init(frame: .zero)
        
        self.segments = segments
        self.selectorStyle = selectorStyle
        self.foregroundColor = .label
        self.selectedForegroundColor = .label
        switch selectorStyle {
        case .fill:
            self.selectorColor = .systemGray3
            self.backgroundColor = .systemFill
        default:
            self.selectorColor = .label
            self.backgroundColor = .systemBackground
        }
        defer {
            self.cornerRadius = cornerRadius
        }
    }
    
    open func appendIconSegment(icon: UIImage? = nil, preserveIconColor: Bool = true, rippleColor: UIColor) {
        self.preserveIconColor = preserveIconColor
        let button = UIButton()
        button.setImage(icon)
        button.setTitle(nil, for: .normal)
        button.layer.cornerRadius = self.cornerRadius
        self.segments.append(button)
    }
    
    open func appendSegment(icon: UIImage? = nil, text: String? = nil,
                            textColor: UIColor?, font: UIFont? = nil, rippleColor: UIColor)
    {
        let button = UIButton()
        button.setImage(icon)
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.layer.cornerRadius = self.cornerRadius
        self.segments.append(button)
    }
    
    open func appendTextSegment(text: String, textColor: UIColor?, font: UIFont? = nil,
                                rippleColor: UIColor)
    {
        appendSegment(text: text, textColor: textColor, font: font, rippleColor: rippleColor)
    }
    
    func updateViews() {
        guard segments.count > 0 else { return }
        
        for idx in 0 ..< segments.count {
            segments[idx].backgroundColor = .clear
            segments[idx].addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            segments[idx].tag = idx
        }
        
        // Create a StackView
        stackView = UIStackView(arrangedSubviews: segments)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        selector = SelectorView(frame: .zero)
        selector.setCornerBorder(cornerRadius: 4)
        
        switch selectorStyle {
        case .fill, .line:
            selector.backgroundColor = .green
        case .outline:
            selector.setCornerBorder(color: selectorColor, cornerRadius: selector.layer.cornerRadius, borderWidth: 1.5)
        }
        
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        [selector, stackView].forEach { view in
            guard let view = view else { return }
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if let firstBtn = segments.first {
            buttonTapped(button: firstBtn)
        }
        
        layoutSubviews()
    }

    // AutoLayout
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        selector.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing).isActive = true
        switch selectorStyle {
        case .fill, .outline:
            selector.topAnchor.constraint(equalTo: topAnchor, constant: spacing).isActive = true
        case .line:
            selector.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        }
        
        if let selector = selector, let first = stackView.arrangedSubviews.first {
            // TODO check type
            addConstraint(NSLayoutConstraint(item: selector, attribute: .width, relatedBy: .equal, toItem: first, attribute: .width, multiplier: 1, constant: 0.0))
        }
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor // TODO check type
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 8
        
        layoutIfNeeded()
    }
    
    @objc func buttonTapped(button: UIButton) {
        for (idx, btn) in segments.enumerated() {
            let image = btn.image(for: .normal)
            btn.setTitleColor(foregroundColor, for: .normal)
            btn.setImage(preserveIconColor ? image : image?.colored(foregroundColor))
            
            if btn.tag == button.tag {
                selectedSegmentIndex = idx
                btn.setImage(preserveIconColor ? image : image?.colored(selectedForegroundColor))
                btn.setTitleColor(selectorStyle == .line ? foregroundColor : selectedForegroundColor, for: .normal)
                moveView(selector, toX: btn.frame.origin.x)
            }
        }
        sendActions(for: .valueChanged)
    }

    /**
     Moves the view to the right position.
     
     - Parameter view:       The view to be moved to new position.
     - Parameter duration:   The duration of the animation.
     - Parameter completion: The completion handler.
     - Parameter toView:     The targetd view frame.
     */
    open func moveView(_ view: UIView, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil, toX: CGFloat) {
        view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: 0.0)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: { () in
                           view.transform = CGAffineTransform(translationX: toX, y: 0.0)
                       }, completion: completion)
    }
}

public extension UIView {
    func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 8.0, borderWidth: CGFloat = 1.5) {
        layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}

public extension UIButton {
    func setImage(_ image: UIImage?) {
        for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            setImage(image, for: state)
        }
    }
}

public extension UIImage {
    func colored(_ color: UIColor) -> UIImage? {
        withRenderingMode(.alwaysTemplate)
        withTintColor(color)
        return self
    }
}
