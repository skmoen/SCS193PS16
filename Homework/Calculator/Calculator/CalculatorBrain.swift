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
    private lazy var formatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
    
    var varialbeValues = [String:Double]() {
        didSet {
            // if we change variables, re-run our program
            program = internalProgram
        }
    }
    
    var result: Double {
        return accumulator
    }
    
    var description: String {
        var desc = ""
        var last: String?
        for item in internalProgram {
            if let operand = item as? Double {
                last = formatter.stringFromNumber(operand)
            } else if let symbol = item as? String {
                if let operation = operations[symbol] {
                    switch operation {
                    case .Constant(let symbol, _):
                        last = symbol
                    case .UnaryOperation(let symbol, _, _):
                        desc = (last != nil ? desc : "") + symbol + "(" + (last ?? desc) + ")"
                        last = nil
                    case .BinaryOperation(let symbol, _, _):
                        desc += (last ?? "") + symbol
                    case .Equals:
                        desc += last ?? ""
                        last = nil
                    }
                } else {
                    last = symbol
                }
            } else {
                print("Unable to process: \(item)")
            }
        }
        return desc == "" ? last ?? "" : desc
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
                    } else if let symbol = op as? String {
                        if operations[symbol] != nil {
                            performOperation(symbol)
                        } else {
                            setOperand(symbol)
                        }
                    }
                }
            }
        }
    }
    
    private struct PendingBinaryInfo {
        var binaryFunction: (Double, Double) -> Double
        var operand: Double
        var validator: ((Double, Double) -> String?)?
    }
    
    // MARK: - Functions
    func setOperand(operand: Double) {
        // if we press an operand with no pending operator, reset internal program
        if pending == nil { clear() }
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func setOperand(variable: String) {
        if pending == nil { clear() }
        accumulator = varialbeValues[variable] ?? 0
        internalProgram.append(variable)
    }
    
    func validateOperation(symbol: String, operand: Double?) -> String? {
        let currentOperand = operand ?? accumulator
        if let op = operations[symbol] {
            switch op {
            case .UnaryOperation(_, _, let validator):
                return validator?(currentOperand)
            case .BinaryOperation(_, _, _): fallthrough
            case .Equals:
                return pending != nil ? pending!.validator?(pending!.operand, currentOperand) : nil
            default: break
            }
        }
        return nil
    }
    
    func performOperation(symbol: String) {
        if let op = operations[symbol] {
            switch op {
            case .Constant(_, let value):
                if pending == nil { clear() }
                accumulator = value
            case .UnaryOperation(_, let function, _):
                accumulator = function(accumulator)
            case .BinaryOperation(_, let function, let validator):
                executePendingBinaryOperation()
                pending = PendingBinaryInfo(binaryFunction: function, operand: accumulator, validator: validator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
        internalProgram.append(symbol)
    }
    
    func clear() {
        accumulator = 0
        pending = nil
        internalProgram.removeAll()
    }
    
    func undo() -> Double? {
        var returnValue: Double? = nil
        if internalProgram.count > 0 {
            internalProgram.removeLast()
            if internalProgram.last as? Double != nil {
                returnValue = internalProgram.removeLast() as? Double
            }
            program = internalProgram
        }
        return returnValue
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.operand, accumulator)
            pending = nil
        }
    }
    
    private func evaluatePendingBinaryOperation() -> Double? {
        if pending != nil {
            return pending!.binaryFunction(pending!.operand, accumulator)
        }
        return nil
    }
    
    // MARK: - Operations
    private enum Operation {
        case Constant(String, Double)
        case UnaryOperation(String, Double -> Double, (Double -> String?)?)
        case BinaryOperation(String, (Double, Double) -> Double, ((Double, Double) -> String?)?)
        case Equals
    }
    
    private let operations = [
        "π": Operation.Constant("π", M_PI),
        "e": Operation.Constant("e", M_E),
        "√": Operation.UnaryOperation("√", sqrt, {$0 < 0 ? "Square Root of Negative is Not a Number (NaN) - Imaginary!" : nil}),
        "sin": Operation.UnaryOperation("sin", sin, nil),
        "cos": Operation.UnaryOperation("cos", cos, nil),
        "×": Operation.BinaryOperation("×", {$0 * $1}, nil),
        "÷": Operation.BinaryOperation("÷", {$0 / $1}, {$1 == 0 ? "Dividing by Zero results in Infinity (∞)!": nil}),
        "+": Operation.BinaryOperation("+", {$0 + $1}, nil),
        "−": Operation.BinaryOperation("-", {$0 - $1}, nil),
        "=": Operation.Equals,
    ]
}