//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Moen on 5/8/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {
    // MARK: - Properties
    private var userIsTyping = false
    private var brain = CalculatorBrain()
    
    private var displayValue: Double {
        get { return Double(display.text!)! }
        set { display.text = String(newValue) }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var display: UILabel!
    
    
    // MARK: - IBActions
    @IBAction private func touchDigit(sender: UIButton) {
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
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        displayValue = brain.result
    }
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        brain.program = savedProgram!
        displayValue = brain.result
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculatorCount += 1
        print("Loaded up new Calculator; count = \(calculatorCount)")
        
//        brain.addUnaryOperation("Z") { [unowned self] in
//          self.display.textColor = UIColor.redColor()

        brain.addUnaryOperation("Z") { [weak  weakSelf = self] in
            weakSelf?.display.textColor = UIColor.redColor()
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator left heap; count = \(calculatorCount)")
    }
}
