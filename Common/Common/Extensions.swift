//
//  Extensions.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import UIKit


public extension UIView {
    func makeCard() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
    }
    
    func setShade() {
        self.layer.cornerRadius = 0
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
    }

    func makeCardRadius_2() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
    }

    func underlined(borderColor color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0,
                                  y: self.frame.height - 1,
                                  width: self.frame.width,
                                  height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }

    func removeUnderline() {
        for sub in self.layer.sublayers! {
            sub.removeFromSuperlayer()
        }
    }

    func removeBorders() {
        self.layer.borderWidth = 0.0
    }

    func makeRound(_ cornerRadius: Int, borderWidth width: CGFloat, borderColor color: UIColor) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func makeCircular(borderWidth width: CGFloat, borderColor color: UIColor) {
        self.layer.cornerRadius = 0.5 * self.bounds.height
        self.layer.borderWidth = width
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
    }

    func setAccessibilityIdentifier(usingName name: String) {
        self.accessibilityIdentifier = name
    }
}

public extension UITableView {
   

    func removeEmptyCells() {
        self.tableFooterView = UIView()
    }
}

public extension UIImageView {

    func makeCircle() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.contentMode = .scaleAspectFill
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

}

public extension UIButton {
    func decorateButtonRound() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }

    func decorateButtonCardAndRound() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }

    func decorateButtonRound(_ cornerRadius: Int) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }

    func decorateButtonRound(_ cornerRadius: Int, borderWidth: CGFloat) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.gray.cgColor
    }

    func decorateButton() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }

    func makeCircle() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
    }
}

public extension UITextField {
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }

    func makeCircle() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
    }

    func makeRound() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }

    func setCustomTextRect() {
        self.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
    }

    func setPlaceholder(withText text: String, usingColor color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    
}

public extension UITextView {
    func setCustomTextRect(withTopPadding padding: CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: padding, left: 10, bottom: 0, right: 10)
    }

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

public extension UILabel {
    func makeRound() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
}

public extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }

    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
}

public extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

//public extension UIScrollView {
//    // Scroll to a specific view so that it's top is at the top our scrollview
//    func scrollToView(view: UIView, animated: Bool) {
//        if let origin = view.superview {
//            // Get the Y position of your child view
//            let childStartPoint = origin.convert(view.frame.origin, to: self)
//            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
//            self.scrollRectToVisible(
//                CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height),
//                                     animated: animated)
//        }
//    }
//
//    // Bonus: Scroll to top
//    func scrollToTop(animated: Bool) {
//        let topOffset = CGPoint(x: 0, y: -contentInset.top)
//        setContentOffset(topOffset, animated: animated)
//    }
//
//    // Bonus: Scroll to bottom
//    func scrollToBottom(animated: Bool) {
//        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
//        if bottomOffset.y > 0 {
//            setContentOffset(bottomOffset, animated: animated)
//        }
//    }
//}

public extension UIApplication {
    class func topViewController(
        controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController {

    func preloadView() {
        _ = view
    }
}


public extension UIColor {
    
    static let primaryColor = UIColor("#411D59")

}
