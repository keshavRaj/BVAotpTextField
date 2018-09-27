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
    case top = 1, middle, bottom, rect
}

protocol BVAPasswordTextFielDelegate: class {
    func textDidChange(_ field: BVAPasswordTextField, text: String)
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
    @IBInspectable var borderColor: UIColor = UIColor.gray
    @IBInspectable var textColor: UIColor = UIColor.black
    @IBInspectable var imageWidth: CGFloat = 0 //Change from 0 to give the image width
    
    public weak var delegate: BVAPasswordTextFielDelegate?
    public var value = ""
    
    private var _borderType: BVAPasswordBorderType?
    private var _labels = [UILabel]()
    private var _imageViews = [UIImageView]()
    private var _borderFeelViews = [UIView]()
    private var _isLayoutForFirstTime = true
    private var _inputCount: Int!
    private var _currentIndex = 0
    
    public var keyboardType: UIKeyboardType = .numberPad
    override var canBecomeFirstResponder: Bool {
        if _currentIndex < _inputCount {
            flashAnimation(at: _currentIndex)
        }
        return true
    }
    override var canResignFirstResponder: Bool {
        if _currentIndex < _inputCount {
            removeAnimation(at: _currentIndex, shouldHide: false)
        }
        return true
    }
    
    
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
        _inputCount = inputCount
        let labelSpacing = textSpacing > 0 ? textSpacing : getLabelSpacing()
        for i in 0 ..< inputCount {
            //Create labels
            let label = UILabel()
            label.font = font
            label.textColor = textColor
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            _labels.append(label)
            
            //Add border feeling
            if let borderType = _borderType,
                borderType != .rect,
                placeholderImage == nil {
                let border = UIView()
                border.translatesAutoresizingMaskIntoConstraints = false
                border.backgroundColor = borderColor
                _borderFeelViews.append(border)
                label.addSubview(border)
                
                let views = [
                    "label": label,
                    "border": border
                ]
                let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[border]|", options: [], metrics: nil, views: views)
                let heightConstraint = NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
                var verticalAllignmentConstraint: NSLayoutConstraint?
                switch borderType {
                case .bottom:
                    verticalAllignmentConstraint = border.bottomAnchor.constraint(equalTo: label.bottomAnchor)
                    
                case .top:
                    verticalAllignmentConstraint = border.topAnchor.constraint(equalTo: label.topAnchor)
                    
                case .middle:
                    verticalAllignmentConstraint = NSLayoutConstraint(item: border, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0)
                default:
                    break
                }
                if let vConstraint = verticalAllignmentConstraint {
                NSLayoutConstraint.activate(horizontalConstraint + [heightConstraint, vConstraint])
                }
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
            if let borderType = _borderType,
                borderType == .rect,
                placeholderImage == nil {
                label.layer.borderWidth = 1
                label.layer.borderColor = borderColor.cgColor
                label.layer.masksToBounds = true
            }
            
            //Create imageViews
            if placeholderImage != nil {
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
        if !isFirstResponder {
            becomeFirstResponder()
        }
        debugPrint("Becoming first responder")
    }
}

extension BVAPasswordTextField: UIKeyInput {
    
    public var hasText: Bool {
        return !(value.isEmpty)
    }
    
    
    public func insertText(_ text: String) {
        debugPrint("\(text)")
        if _currentIndex < _inputCount { //Else we are not processing the entered text as input count will increase
            value.append(text)
            delegate?.textDidChange(self, text: value)
            removeAnimation(at: _currentIndex)
            _labels[_currentIndex].text = text
            _currentIndex += 1
            if _currentIndex < _inputCount {
                flashAnimation(at: _currentIndex)
            }
            
        }
    }
    
    public func deleteBackward() {
        debugPrint("Delete pressed")
        if _currentIndex != 0 {
            if _currentIndex != _inputCount {
                removeAnimation(at: _currentIndex, shouldHide: false)
            }
            _currentIndex -= 1
            _labels[_currentIndex].text = nil
            flashAnimation(at: _currentIndex)
            value = String(value.dropLast())
            delegate?.textDidChange(self, text: value)
        }
        
    }
}

//MARK:- Animation
extension BVAPasswordTextField {
    func flashAnimation(at index: Int) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.4
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if placeholderImage != nil {
            _imageViews[index].isHidden = false
            _imageViews[index].layer.add(animation, forKey: "flashAnimation")
        } else {
            if let borderType = _borderType,
                borderType != .rect {
                _borderFeelViews[index].isHidden = false
                _borderFeelViews[index].layer.add(animation, forKey: "flashAnimation")
            }
        }
    }
    
    func removeAnimation(at index: Int, shouldHide: Bool = true) {
        if placeholderImage != nil {
            _imageViews[index].layer.removeAllAnimations()
            _imageViews[index].isHidden = shouldHide
        } else {
            if let borderType = _borderType,
                borderType != .rect {
                _borderFeelViews[index].layer.removeAllAnimations()
                _borderFeelViews[index].isHidden = shouldHide
            }
        }
    }
}
