//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Moen on 5/11/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    // MARK: - Properties
    private var userIsTyping = false
    private var brain = CalculatorBrain()
    private lazy var formatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
    
    private var displayValue: Double? {
        get { return Double(display.text!) }
        set {
            display.text = newValue != nil ? formatter.stringFromNumber(newValue!) : ""
            history.text = brain.description + (!brain.description.isEmpty ? (brain.isPartialResult ? "…" : "=") : "")
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var display: UILabel!
    @IBOutlet weak private var history: UILabel!
    
    // MARK: - IBAction
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsTyping {
            // make sure we aren't adding a second period
            if digit == "." && display.text!.rangeOfString(".") != nil { return }
            
            // make sure we aren't entering a bunch of zero's
            if digit == "0" && display.text! == "0" { return }
            
            display.text = display.text! + digit
        } else {
            display.text = (digit == "." ? "0" : "") + digit
            userIsTyping = true
        }
    }
    
    @IBAction private func touchOperation(sender: UIButton) {
        if let message = brain.validateOperation(sender.currentTitle!, operand: userIsTyping ? displayValue! : nil) {
            let alert = UIAlertController(title: "Arithmetic Error", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) in self.performOperation(sender.currentTitle!) }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            performOperation(sender.currentTitle!)
        }
    }
    
    private func performOperation(symbol: String) {
        if userIsTyping {
            brain.setOperand(displayValue!)
            userIsTyping = false
        }
        
        brain.performOperation(symbol)
        displayValue = brain.result
    }
    
    @IBAction private func randomNumber() {
        if userIsTyping {
            brain.setOperand(displayValue!)
        }

        display.text = formatter.stringFromNumber(drand48())
        userIsTyping = true
    }
    
    @IBAction private func memoryStore() {
        userIsTyping = false
        brain.varialbeValues["M"] = displayValue
        displayValue = brain.result
    }
    
    @IBAction private func memoryPush() {
        brain.setOperand("M")
        displayValue = brain.result
    }

    @IBAction private func clear() {
        // make managing the `M` variable the responsibility of controller
        brain.varialbeValues.removeValueForKey("M")
        brain.clear()
        displayValue = nil
    }
    
    @IBAction private func backspace() {
        if userIsTyping {
            display.text!.removeAtIndex(display.text!.endIndex.predecessor())
            
            if display.text!.isEmpty {
                displayValue = nil
                userIsTyping = false
            }
        } else {
            if let operand = brain.undo() {
                displayValue = operand
                userIsTyping = true
            } else {
                displayValue = brain.result
                userIsTyping = false
            }
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // we will not perform segue if the brain has a partial result
        return !brain.isPartialResult
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "graph" {
            let dvc = (segue.destinationViewController as! UINavigationController).topViewController as! GraphViewController
            dvc.program = brain.program
        }
    }
}
