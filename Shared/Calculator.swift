//
//  Calculator.swift
//  HW 2 Alternating Series
//
//  Created by Michael Cardiff on 2/3/22.
//

import Foundation
import SwiftUI

typealias returnsDouble = (_ parameters: Int) -> Double

class Calculator: ObservableObject {
    
    /// calculateFiniteSum
    /// Calculate the following sum:
    //        max
    //        ___
    // sum =  \    f(n)
    //        /__
    //      n = min
    func calculateFiniteSum(function: returnsDouble, minimum: Int, maximum: Int) -> Double {
        
        var sum = 0.0
        
        for n in minimum...maximum {
            sum += function(n)
        }
        
        return sum
    }
    
    func sumOneTerm(n: Int) -> Double {
        let numerator = pow(-1.0, Double(n)) * Double(n)
        let denominator = Double(n + 1)
        return numerator / denominator
    }
    
    func sumTwoOddTerm(n: Int) -> Double {
        let numerator = -1.0 * Double(2*n - 1)
        let denominator = Double(2*n)
        return numerator / denominator
    }
    
    func sumTwoEvenTerm(n: Int) -> Double {
        let numerator = Double(2*n)
        let denominator = Double(2*n + 1)
        return numerator / denominator
    }
    
    func sumThreeTerm(n: Int) -> Double {
        let denominator = Double(2*n * (2*n + 1))
        return 1.0 / denominator
    }
    
    
    func calcErr(actual: Double, calculated: Double) -> Double {
        return abs(actual - calculated) / actual
    }
    
    func calcRelDifference(up: Double, down: Double) -> Double {
        return abs(up - down) / (abs(up) + abs(down))
    }
}

