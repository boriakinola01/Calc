//
//  CalcModel.Operation.swift
//  Calc
//
//  Created by Bori Akinola on 05/10/2023.
//

import Foundation

extension CalcModel {
    enum Operation: CustomStringConvertible {
        static var supportedOperators = [String: Operation]()
        
        case operand(Double)
        case unaryOperator(String, (Double) -> Double)
        case binaryOperator(String, (Double, Double) -> Double)
        
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
    }
}
