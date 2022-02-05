//
//  HW_2_Alternating_SeriesApp.swift
//  Shared
//
//  Created by Michael Cardiff on 2/3/22.
//

import SwiftUI

@main
struct HW_2_Alternating_SeriesApp: App {
    
    @StateObject var plotData = PlotClass()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .environmentObject(plotData)
                    .tabItem {
                        Text("Plot")
                    }
                TextView()
                    .environmentObject(plotData)
                    .tabItem {
                        Text("Text")
                    }
            }
        }
    }
}
