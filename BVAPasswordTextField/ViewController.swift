//
//  ViewController.swift
//  BVAPasswordTextField
//
//  Created by Keshav Raj on 26/09/18.
//  Copyright © 2018 Keshav Raj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BVAPasswordTextFielDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var passwordField: BVAPasswordTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.userTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("Touch view is \(touch.view == self.view)")
//        return touch.view == self
//    }
    
    @objc func userTapped() {
        print("User tapped")
        view.endEditing(true)
    }
    
    func textDidChange(_ field: BVAPasswordTextField, text: String) {
        print("Text is \(text)")
    }



}

