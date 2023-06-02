//
//  ViewController.swift
//  ThemeExample
//
//  Created by Elvis Mwenda on 08/05/2023.
//

import UIKit

class ViewController: UIViewController {
//    let segmentedControl = CustomSegmentedControl(items: ["", ""])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Note: you may need to set the layout contraints for it by yourself
        // to make it displayed correctly.
        let segmentedControl = OMKSegmentedControl(frame: CGRect(x: 12, y: 100, width: UIScreen.main.bounds.width - 24, height: 32))
        
        // Configure the view, note that you need to call updateViews in order to apply your cofiguration.
        segmentedControl.selectorColor = .black
        segmentedControl.selectorStyle = .fill
//        segmentedControl.selectorTextColor = .black
        setSampleSegments(segmentedControl, 18.0)
        segmentedControl.updateViews()
        
        self.view.addSubview(segmentedControl)
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
    }
    
    /**
    Create sample segments for the segmented control.
    - Parameter segmentedControl: The segmented control to put these segments into.
    - Parameter cornerRadius:     The corner radius to be set to segments and selectors.
    */
    private func setSampleSegments(_ segmentedControl: OMKSegmentedControl, _ cornerRadius: CGFloat) {
        for i in 0..<3 {
            // Button background needs to be clear, it will be set to clear in segmented control anyway.
//            let button = MaterialButton(text: "Segment \(i)", textColor: .gray, bgColor: .clear, cornerRadius: cornerRadius)
            let button = UIButton()
            button.setTitle("Segment \(i)", for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = cornerRadius
            segmentedControl.segments.append(button)
        }
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

