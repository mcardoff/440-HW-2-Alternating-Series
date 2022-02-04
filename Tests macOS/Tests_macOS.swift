//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Michael Cardiff on 2/3/22.
//

import XCTest

class Tests_macOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // find the following sum
    //        N
    //       ___        n(n + 1)
    //       \    n  =  --------
    //       /__            2
    //       n=1
    func testSeries() throws {
        // test sum of n, gauss formula
        let calc = Calculator()
        let n = 100
        let actual = Double(n * (n+1) / 2)
        let calculated = calc.calculateFiniteSum(function: {(n:Int) -> Double in return	Double(n)}, minimum: 1, maximum: n)
        
        XCTAssertEqual(actual, calculated, accuracy: 1.0e-15, "Not accurate enough")
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
