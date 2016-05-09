//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Moen on 5/8/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsTyping = false
    
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else {
            display.text = digit
        }
        
        userIsTyping = true
    }
    
    @IBAction func performOperation(sender: UIButton) {
        if let symbol = sender.currentTitle {
            if symbol == "π" {
                display.text = String(M_PI)
            }
        }
        userIsTyping = false
    }
}
