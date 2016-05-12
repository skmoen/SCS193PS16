//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Scott Moen on 5/11/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import Foundation


class CalculatorBrain {
    // MARK: - Properties
    private var accumulator = 0.0
    private var history = [Element]()
    private var pending: PendingBinaryInfo?
    
    var result: Double {
        return accumulator
    }
    
    var description: String {
        return "hi"
    }
    
    var isPartialResult: Bool {
        return pending != nil
    }
    
    private struct PendingBinaryInfo {
        var binaryFunction: (Double, Double) -> Double
        var operand: Double
    }
    
    private enum Element {
        case Number(Double)
        case Symbol(Operation)
    }
    
    // MARK: - Functions
    func setOperand(operand: Double) {
        accumulator = operand
        history.append(.Number(operand))
    }
    
    func performOperation(operation: String) {
        if let op = operations[operation] {
            history.append(.Symbol(op))
            switch op {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryInfo(binaryFunction: function, operand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func clear() {
        accumulator = 0
        pending = nil
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.operand, accumulator)
            pending = nil
        }
    }
    
    // MARK: - Operations
    private enum Operation {
        case Constant(Double)
        case UnaryOperation(Double -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private let operations = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "sin": Operation.UnaryOperation(sin),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation{ $0 * $1 },
        "÷": Operation.BinaryOperation{ $0 / $1 },
        "+": Operation.BinaryOperation{ $0 + $1 },
        "−": Operation.BinaryOperation{ $0 - $1 },
        "=": Operation.Equals,
    ]
}