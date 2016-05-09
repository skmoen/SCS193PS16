//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Scott Moen on 5/8/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import Foundation

class CalculatorBrain {
    // MARK: - Properties
    private var accumulator = 0.0
    
    var result: Double {
        return accumulator
    }
    
    // MARK: - Public Functions
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func performOperation(operation: String) {
        switch operation {
        case "π": accumulator = M_PI
        case "√": accumulator = sqrt(accumulator)
        default: break
        }
    }
    
}