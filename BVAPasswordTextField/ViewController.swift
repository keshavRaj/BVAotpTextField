//
//  ViewController.swift
//  BVAPasswordTextField
//
//  Created by Keshav Raj on 26/09/18.
//  Copyright © 2018 Keshav Raj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BVAPasswordTextFielDelegate {

    @IBOutlet weak var passwordField: BVAPasswordTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
       // view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func userTapped() {
        view.endEditing(true)
    }
    
    func textDidChange(_ field: BVAPasswordTextField, text: String) {
        print("Text is \(text)")
    }



}

