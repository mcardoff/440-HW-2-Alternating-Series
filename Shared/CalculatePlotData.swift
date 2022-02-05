//
//  CalculatePlotData.swift
//  SwiftUICorePlotExample
//
//  Created by Jeff Terry on 12/22/20.
//

import Foundation
import SwiftUI
import CorePlot

class CalculatePlotData: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var theText = ""
    
    
    @MainActor func setThePlotParameters(color: String, xLabel: String, yLabel: String, title: String) {
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 10.0
        plotDataModel!.changingPlotParameters.yMin = -5.0
        plotDataModel!.changingPlotParameters.xMax = 10.0
        plotDataModel!.changingPlotParameters.xMin = -5.0
        plotDataModel!.changingPlotParameters.xLabel = xLabel
        plotDataModel!.changingPlotParameters.yLabel = yLabel
        
        if color == "Red"{
            plotDataModel!.changingPlotParameters.lineColor = .red()
        }
        else{
            
            plotDataModel!.changingPlotParameters.lineColor = .blue()
        }
        plotDataModel!.changingPlotParameters.title = title
        
        plotDataModel!.zeroData()
    }
    
    @MainActor func appendDataToPlot(plotData: [plotDataType]) {
        plotDataModel!.appendData(dataPoint: plotData)
    }
    
    func plotYEqualsX() async {
        await plotFunc(fun: {(x:Double) -> Double in return x}, funcName: "y = x", color: "Blue")
    }
    
    
    func ploteToTheMinusX() async {
        await plotFunc(fun: {(x:Double) -> (Double) in return exp(-x)}, funcName: "y = exp(-x)", color: "Red")
        return
    }
    
    func plotLogLogErr() async {
        let calculator = Calculator()
        //set the Plot Parameters
        await setThePlotParameters(color: "Red",
                    xLabel: "x", yLabel: "Log(Err)", title: "log log plot")
        await resetCalculatedTextOnMainThread()
        
        var plotData :[plotDataType] =  []
        for n in 1 ..< 1000 {
            let s1Double = calculator.calculateFiniteSum(
                function: calculator.sumOneTerm(n:), minimum: 0, maximum: 2*n)
            let s3Double = calculator.calculateFiniteSum(
                function: calculator.sumThreeTerm(n:), minimum: 0, maximum: n)
            //create x values here
            let x = Double(n)
            let logx = log10(x)
            //create y values here
            let y = log10(calculator.calcErr(actual: s3Double, calculated: s1Double))
            
            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(contentsOf: [dataPoint])
            theText += "x = \(logx), y = \(y)\n"
        }
        
        await appendDataToPlot(plotData: plotData)
        await updateCalculatedTextOnMainThread(theText: theText)
    }
    
    func plotFunc(fun: ((Double) -> Double), funcName: String, color: String) async {
        
        //set the Plot Parameters
        await setThePlotParameters(color: color, xLabel: "x", yLabel: funcName, title: funcName)
        await resetCalculatedTextOnMainThread()
        
        var plotData :[plotDataType] =  []
        for i in 0 ..< 60 {

            //create x values here
            let x = -2.0 + Double(i) * 0.2

            //create y values here
            let y = fun(x)
            
            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(contentsOf: [dataPoint])
            theText += "x = \(x), y = \(y)\n"
        }
        
        await appendDataToPlot(plotData: plotData)
        await updateCalculatedTextOnMainThread(theText: theText)
        
        return
    }
    
    
    @MainActor func resetCalculatedTextOnMainThread() {
        //Print Header
        plotDataModel!.calculatedText = ""
        
    }
    
    
    @MainActor func updateCalculatedTextOnMainThread(theText: String) {
        //Print Header
        plotDataModel!.calculatedText += theText
    }
    
}



