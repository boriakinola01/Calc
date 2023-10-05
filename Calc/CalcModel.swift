//
//  CalcModel.swift
//  Calc
//
//  Created by Bori Akinola on 23/09/2023.
//

import Foundation

struct CalcModel {
    private var stack = [Double]()
    
    var supportedOperators: [String: Operation]
    
    enum Operation: CustomStringConvertible {
        var description: String {
            switch self {
            case .operand(let value):
                return "\(value)"
            case .binaryOperator(let symbol, _):
                fallthrough
            case .unaryOperator(let symbol, _):
                return symbol
            }
        }
        
        case operand(Double)
        case unaryOperator(String, (Double) -> Double)
        case binaryOperator(String, (Double, Double) -> Double)
    }
    
    init() {
        func newOperator(_ operation: Operation) {
            supportedOperators[operation.description] = operation
        }
        
        newOperator(.binaryOperator("+", +))
        newOperator(.binaryOperator("×", *))
        newOperator(.binaryOperator("÷", {$1 / $0}))
        newOperator(.binaryOperator("-", {$1 - $0}))
        newOperator(.unaryOperator("±", -))
    }
    
    mutating func pushOperand(_ operandValue: Double) -> Double? {
        stack.append(operandValue)
        return stack.last
    }
    
    private mutating func evaluateStack() -> Double? {
        
        let (result, leftOverStack) = evaluateStack(stack)
    }
    private mutating func evaluateStack(_ operation: (Double, Double) -> Double) -> Double? {
        if stack.count >= 2 {
            _ = pushOperand(operation(stack.removeLast(), stack.removeLast()))
        }
        return stack.last
    }
    
    private mutating func evaluateStack(_ operation: (Double) -> Double) -> Double? {
        if stack.count >= 1 {
            _ = pushOperand(operation(stack.removeLast()))
        }
        
        return stack.last
    }
    
    private func multiply(_ op1: Double,_ op2: Double) -> Double {
        return op1 * op2
    }
    
    mutating func performOperation(_ operation: String) -> Double?{
        var result: Double?
        switch operation {
        case "+":
            result = evaluateStack(+)
        case "÷":
            result = evaluateStack({(op1: Double, op2: Double) -> Double in return op2/op1})
        case "−":
            result = evaluateStack({$1 - $0})
        case "±":
            result = evaluateStack({-$0})
        case "×":
            result = evaluateStack(multiply)
        default:
            break
        }
        
        return result
    }
}

