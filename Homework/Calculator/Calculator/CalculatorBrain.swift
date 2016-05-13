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
    private var internalProgram = [AnyObject]()
    private var pending: PendingBinaryInfo?
    
    var result: Double {
        return accumulator
    }
    
    var description: String {
        var desc = ""
        var last: String?
        for item in internalProgram {
            if let operand = item as? Double {
                last = String(operand)
            } else if let operation = item as? String, op = operations[operation] {
                switch op {
                case .Constant(let symbol, _):
                    last = symbol
                case .UnaryOperation(let symbol, _):
                    if last != nil {
                        desc += symbol + "(" + last! + ")"
                        last = nil
                    } else {
                        desc = symbol + "(" + desc + ")"
                    }
                case .BinaryOperation(let symbol, _):
                    desc += (last ?? "") + symbol
                case .Equals:
                    desc += last ?? ""
                    last = nil
                }
            } else {
                print("Unable to process: \(item)")
            }
        }
        return desc
    }
    
    var isPartialResult: Bool {
        return pending != nil
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get { return internalProgram }
        set {
            if let arrayOfOps = newValue as? [AnyObject] {
                clear()
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                    
                }
            }
        }
    }
    
    private struct PendingBinaryInfo {
        var binaryFunction: (Double, Double) -> Double
        var operand: Double
    }
    
    // MARK: - Functions
    func setOperand(operand: Double) {
        // if we press an operand with no pending operator, reset internal program
        if pending == nil { clear() }
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func performOperation(operation: String) {
        internalProgram.append(operation)
        if let op = operations[operation] {
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
        pending = nil
        internalProgram.removeAll()
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