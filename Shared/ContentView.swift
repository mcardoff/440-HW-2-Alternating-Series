//
//  ContentView.swift
//  Shared
//
//  Created by Michael Cardiff on 2/3/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    
    @EnvironmentObject var plotData :PlotClass
    @ObservedObject private var calculator = Calculator()
    @ObservedObject private var plotCalculator = CalculatePlotData()
    @State var maxTerms: String = "10"
    @State var s1sum: String = ""
    @State var s2sum: String = ""
    @State var s3sum: String = ""
    @State var s1err: String = ""
    @State var s2err: String = ""
    @State var s3err: String = "Not Defined"
    
    var body: some View {
        VStack {
            CorePlot(dataForPlot: $plotData.plotArray[0].plotData, changingPlotParameters: $plotData.plotArray[0].changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
            
            Divider()
            /*
            HStack(alignment: .center) {
                Text("N:")
                    .font(.callout)
                    .bold()
                TextField("Enter Max Terms", text: $maxTerms, onCommit: self.calculateSums)
                    .frame(width: 100)
                
            }.padding()
            
            HStack {
                // Boxes that contain series values
                VStack {
                    HStack {
                        Text("S(1):")
                            .font(.callout)
                            .bold().frame(width: 50)
                        TextField("S1", text: $s1sum).frame(width: 100)
                    }.padding()
                    
                    HStack {
                        Text("S(2):")
                            .font(.callout)
                            .bold().frame(width: 50)
                        TextField("S2", text: $s2sum).frame(width: 100)
                    }.padding()
                    
                    HStack {
                        Text("S(3):")
                            .font(.callout)
                            .bold().frame(width: 50)
                        TextField("S3", text: $s3sum).frame(width: 100)
                    }.padding()
                }
                // Errors wrt to S3
                VStack {
                    HStack {
                        Text("S(1) Err:")
                            .font(.callout)
                            .bold().frame(width: 50)
                        TextField("S1", text: $s1err).frame(width: 100)
                    }.padding()
                    
                    HStack {
                        Text("S(2) Err:")
                            .font(.callout)
                            .bold().frame(width: 50)
                        TextField("S2", text: $s2err).frame(width: 100)
                    }.padding()
                    
                    HStack {
                        Text("S(3) Err:")
                            .font(.callout)
                            .bold().frame(width: 50)
                        TextField("S3", text: $s3err).frame(width: 100)
                    }.padding()
                }
                
            }
            Button("Calculate Series", action: { self.calculateSums() } )
                .padding()
            */
            HStack{
                Button("exp(-x)", action: {
                    Task.init{ await self.calculatePlots() } } )
                    .padding()
            }
        }
    }
    
    func calculateSums() {
        let s1Double = calculator.calculateFiniteSum(
            function: calculator.sumOneTerm(n:), minimum: 1, maximum: 2*Int(maxTerms)!)
        let s2Even = calculator.calculateFiniteSum(
            function: calculator.sumTwoEvenTerm(n:), minimum: 1, maximum: Int(maxTerms)!)
        let s2Odd = calculator.calculateFiniteSum(
            function: calculator.sumTwoOddTerm(n:), minimum: 1, maximum: Int(maxTerms)!)
        let s3Double = calculator.calculateFiniteSum(
            function: calculator.sumThreeTerm(n:), minimum: 1, maximum: Int(maxTerms)!)
        let s2Double = s2Even + s2Odd
        
        s1sum = String(format: "%0.9f", s1Double)
        s1err = String(format: "%0.9f", log10(calculator.calcErr(actual: s3Double, calculated: s1Double)))
        s2sum = String(format: "%0.9f", s2Double)
        s2err = String(format: "%0.9f", log10(calculator.calcErr(actual: s3Double, calculated: s2Double)))
        s3sum = String(format: "%0.9f", s3Double) // error not calculated for s3
        return
    }
    
    @MainActor func setupPlotDataModel(selector: Int){
        plotCalculator.plotDataModel = self.plotData.plotArray[0]
    }
    
    func calculatePlots() async {
        //pass the plotDataModel to the Calculator
        setupPlotDataModel(selector: 0)
        
        let _ = await withTaskGroup(of:  Void.self) {
            taskGroup in taskGroup.addTask {
                //Calculate the new plotting data and place in the plotDataModel
                await plotCalculator.plotLogLogErr()
                
                // This forces a SwiftUI update. Force a SwiftUI update.
                await self.plotData.objectWillChange.send()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
