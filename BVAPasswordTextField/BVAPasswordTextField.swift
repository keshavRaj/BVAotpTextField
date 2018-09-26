//
//  BVAPasswordTextField.swift
//  BVAPasswordTextField
//
//  Created by Keshav Raj on 26/09/18.
//  Copyright © 2018 Keshav Raj. All rights reserved.
//

import Foundation
import UIKit

enum BVAPasswordBorderType: Int {
    case top = 1, middle, bottom
}

class BVAPasswordTextField: UIControl {
    
    @IBInspectable var placeholderImage: UIImage?
    @IBInspectable var inputCount: Int = 6
    @IBInspectable var font: UIFont = UIFont.systemFont(ofSize: 18)
    @IBInspectable var textSpacing: CGFloat = 0 //Change from 0 to set it
    @IBInspectable var borderType: Int = 0 {
        didSet {
            if let someType = BVAPasswordBorderType(rawValue: borderType) {
                _borderType = someType
            }
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.green
    @IBInspectable var textColor: UIColor = UIColor.black
    @IBInspectable var imageWidth: CGFloat = 0 //Change from 0 to give the image width
    
    private var _borderType: BVAPasswordBorderType?
    private var _labels = [UILabel]()
    private var _imageViews = [UIImageView]()
    private var _borderFeelViews = [UIView]()
    private var _isLayoutForFirstTime = true
    
    public var keyboardType: UIKeyboardType = .numberPad
    override var canBecomeFirstResponder: Bool { return true }
    override var canResignFirstResponder: Bool { return true }
    
    
    init(frame: CGRect, inputCount: Int, font: UIFont? = nil, textColor: UIColor = UIColor.black, borderColor: UIColor = UIColor.red, placeholderImage: UIImage? = nil, placeholderWidth: CGFloat = 0, borderType: BVAPasswordBorderType? = nil) {
        super.init(frame: frame)
        self.placeholderImage = placeholderImage
        self.inputCount = inputCount
        if let someFont = font {
            self.font = someFont
        }
        self.textColor = textColor
        self.borderColor = borderColor
        _borderType = borderType
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(BVAPasswordTextField.showKeyboard), for: .touchUpInside)
    }
    
    
    private func configureUI() {
        let labelSpacing = textSpacing > 0 ? textSpacing : getLabelSpacing()
        for i in 0 ..< inputCount {
            //Create labels
            let label = UILabel()
            label.font = font
            label.textColor = textColor
            label.textAlignment = .center
            label.text = "1"
            label.translatesAutoresizingMaskIntoConstraints = false
            _labels.append(label)
            
            //Add border feeling
            if let borderType = _borderType {
                let border = UIView()
                border.translatesAutoresizingMaskIntoConstraints = false
                border.backgroundColor = borderColor
                label.addSubview(border)
                
                let views = [
                    "label": label,
                    "border": border
                ]
                let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[border]|", options: [], metrics: nil, views: views)
                let heightConstraint = NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
                let verticalAllignmentConstraint: NSLayoutConstraint
                switch borderType {
                case .bottom:
                    verticalAllignmentConstraint = border.bottomAnchor.constraint(equalTo: label.bottomAnchor)
                    
                case .top:
                    verticalAllignmentConstraint = border.topAnchor.constraint(equalTo: label.topAnchor)
                    
                case .middle:
                    verticalAllignmentConstraint = NSLayoutConstraint(item: border, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0)
                }
                NSLayoutConstraint.activate(horizontalConstraint + [heightConstraint, verticalAllignmentConstraint])
            }
            
            //Add it to subview
            addSubview(label)
            
            //Add constraints
            label.topAnchor.constraint(equalTo: topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            if i == 0 { //If it is left most label then allign with it leading
                label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            } else {
                addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: _labels[i - 1], attribute: .trailing, multiplier: 1, constant: labelSpacing))
               addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: _labels[i - 1], attribute: .width, multiplier: 1, constant: 0))
            }
            if i == inputCount - 1 { //last label....Allign trailing with trailing
                label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
            
            //Create imageViews
            let imageView = UIImageView()
            imageView.image = placeholderImage
            imageView.translatesAutoresizingMaskIntoConstraints = false
            _imageViews.append(imageView)
            
            //Add as subview
            addSubview(imageView)
            
            //Add constraints....Allign top, leading, trailing and bottom with label
            imageView.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if _isLayoutForFirstTime {
            configureUI()
            _isLayoutForFirstTime = false
        }
    }
    
    private func getLabelSpacing() -> CGFloat {
        var maxWidth:CGFloat = 0
        for i in 0 ... 9 {
            let text = "\(i)"
            let textAttributes = [NSAttributedStringKey.font: font]
            let textWidth = text.size(withAttributes: textAttributes).width
            if textWidth > maxWidth {
                maxWidth = textWidth
            }
        }
        if imageWidth > maxWidth {
            maxWidth = imageWidth
        }
        return (frame.width - maxWidth * CGFloat(inputCount)) / CGFloat(inputCount - 1)
    }
    
    @objc func showKeyboard() {
        becomeFirstResponder()
    }
}

extension BVAPasswordTextField: UIKeyInput {
    
    
    public var hasText: Bool {
        return false
    }
    
    
    public func insertText(_ text: String) {
        print("\(text)")
    }
    
    public func deleteBackward() {
        
    }
}
