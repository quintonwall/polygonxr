//
//  StockData.swift
//  PolygonXR
//
//  Created by QUINTON WALL on 6/12/24.
//
import Foundation

struct StockData: Codable{
    let results: [StockResult]
    
    
    struct StockResult: Codable, Identifiable  {
        let id = UUID()
        let t: Double //polygon returns a universal date format.
        let c: Double
        
        enum CodingKeys: String, CodingKey {
            case t = "t"
            case c = "c"
        }
    }
    
   
    
}
