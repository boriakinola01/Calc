//
//  CalcModel.swift
//  Calc
//
//  Created by Bori Akinola on 23/09/2023.
//

import Foundation

struct CalcModel {
    private var stack = [Operation]()
    
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
        supportedOperators = [String: Operation]()
        newOperator(.binaryOperator("+", +))
        newOperator(.binaryOperator("×", *))
        newOperator(.binaryOperator("÷", {$1 / $0}))
        newOperator(.binaryOperator("-", {$1 - $0}))
        newOperator(.unaryOperator("±", -))
    }
    
    mutating func pushOperand(_ operandValue: Double) -> Double? {
        stack.append(Operation.operand(operandValue))
        return evaluateStack()
    }
    
    private mutating func evaluateStack() -> Double? {
        func evaluateStack(_ stack: [Operation]) -> (result: Double?, leftOverStack: [Operation]) {
            if !stack.isEmpty {
                var leftOverStack = stack
                let operation = leftOverStack.removeLast()
                switch operation {
                case .operand(let operand):
                    return (operand, leftOverStack)
                case .binaryOperator(_, let operation):
                    let firstEval = evaluateStack(leftOverStack)
                    if let firstEvalResult = firstEval.result {
                        let secondEval = evaluateStack(firstEval.leftOverStack)
                        if let secondEvalResult = secondEval.result {
                            return (operation(firstEvalResult, secondEvalResult), secondEval.leftOverStack)
                        }
                    }
                default:
                    break
                }
            }
            return (nil, stack)
        }
        
        let (result, leftOverStack) = evaluateStack(stack)
        if let evaluation = result {
            print("\(stack) = \(evaluation) with \(leftOverStack) left over")
        }
        
        return result
    }
    
    private func multiply(_ op1: Double,_ op2: Double) -> Double {
        return op1 * op2
    }
    
    mutating func performOperation(_ symbol: String) -> Double?{
        if let operation = supportedOperators[symbol] {
            stack.append(operation)
        }
        
        return evaluateStack()
    }
}

