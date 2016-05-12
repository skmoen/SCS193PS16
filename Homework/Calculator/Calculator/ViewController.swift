//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Moen on 5/11/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    private var userIsTyping = false
    private var brain = CalculatorBrain()
    
    private var displayValue: Double {
        get { return Double(display.text!)! }
        set { display.text = String(newValue) }
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var display: UILabel!
    @IBOutlet weak private var history: UILabel!
    
    // MARK: - IBAction
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsTyping {
            // make sure we aren't adding a second period
            if digit != "." || display.text!.rangeOfString(".") == nil {
                display.text = display.text! + digit
            }
        } else {
            let leading = digit == "." ? "0" : ""  // add leading 0 for decimal
            display.text = leading + digit
            userIsTyping = true
        }
        
    }

    @IBAction private func touchOperation(sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        
        brain.performOperation(sender.currentTitle!)
        
        displayValue = brain.result
        history.text = brain.description + (brain.isPartialResult ? "…" : "=")
    }
    
    @IBAction func clear() {
        brain.clear()
    }
}
