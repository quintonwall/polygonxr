//
//  ContentView.swift
//  PolygonXR
//
//  Created by QUINTON WALL on 6/12/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Charts

struct ContentView: View {
    @State private var stockData: StockData?
    @State private var scale: CGFloat = 1.0
    @State private var tickerText = ""
    
    
    var body: some View {
        NavigationSplitView {
            VStack {
                        TextField("Enter stock ticker", text: $tickerText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            submitAction()
                        }) {
                            Text("Submit")
                                .padding()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
            .navigationTitle("Polygon.io Demo")
        } detail: {
            VStack {
                if let stockData = stockData {
                    Chart {
                        ForEach(stockData.results) { dataPoint in
                            
                            
                            BarMark(
                                x: .value("X", PolygonClient.shared.convertUnixTimeToDateString(unixTime: dataPoint.t)),
                                y: .value("Y", dataPoint.c)
                            )
                        }
                        
                    }
                    .chartYAxis {
                        AxisMarks(values: .stride(by: 20)) {
                            
                            AxisValueLabel(format: Decimal.FormatStyle.Currency(code: "USD"))
                        }
                    }
                    
                } else {
                    Text("Enter a stocker ticker")
                }
            }
            .navigationTitle("Stock Information")
            .padding(10)
            .onAppear {
                
                //PolygonClient.shared.testFetch()
            }
            .scaleEffect(scale)
            .contentShape(Rectangle())
                        .gesture(MagnificationGesture()
                                    .onChanged({ value in
                            scale = value
                            print(value)
                        }))
        }
       
    }
    
    
    private func fetchAggregates(symbol: String) {
        print("Fetching aggregates for "+symbol)
        
        PolygonClient.shared.fetchAggregates(symbol: symbol, multiplier: 1, timespan: "month", from: "2022-06-01", to: "2024-06-05", sort: "asc") { Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.stockData = data
                }
            case .failure(let error):
                print("Error fetching stock data: \(error)")
            }
        }

    }
    
    func submitAction() {
        fetchAggregates(symbol: tickerText)
    }
    
    func formatAsDollars(_ value: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        //return formatter.string(for: value) ?? "$0"
        }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
