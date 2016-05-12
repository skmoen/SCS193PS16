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
        var desc = ""
        for element in history {
            switch element {
            case .Number(let number):
                desc += String(number)
            case .Symbol(let operation):
                switch operation {
                case .Constant(let symbol, _):
                    desc += symbol
                case .UnaryOperation(let symbol, _):
                    desc = symbol + "(" + desc + ")"
                case .BinaryOperation(let symbol, _):
                    desc += symbol
                case .Equals:
                    break
                }
            }
        }
        return desc
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
            case .Constant(_, let value):
                accumulator = value
            case .UnaryOperation(_, let function):
                accumulator = function(accumulator)
            case .BinaryOperation(_, let function):
                executePendingBinaryOperation()
                pending = PendingBinaryInfo(binaryFunction: function, operand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func clear() {
        accumulator = 0
        history.removeAll()
        pending = nil
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.operand, accumulator)
            pending = nil
        }
    }
    
    // MARK: - Operations
    private enum Operation: CustomStringConvertible {
        case Constant(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Equals
        
        var description: String {
            switch self {
            case .Constant(let name, _): return name
            case .UnaryOperation(let name, _): return name
            case .BinaryOperation(let name, _): return name
            default: return ""
            }
        }
    }
    
    private let operations = [
        "π": Operation.Constant("π", M_PI),
        "e": Operation.Constant("e", M_E),
        "√": Operation.UnaryOperation("√", sqrt),
        "sin": Operation.UnaryOperation("sin", sin),
        "cos": Operation.UnaryOperation("cos", cos),
        "×": Operation.BinaryOperation("×") { $0 * $1 },
        "÷": Operation.BinaryOperation("÷") { $0 / $1 },
        "+": Operation.BinaryOperation("+") { $0 + $1 },
        "−": Operation.BinaryOperation("-") { $0 - $1 },
        "=": Operation.Equals,
    ]
}