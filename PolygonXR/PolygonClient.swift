//
//  PolygonClient.swift
//  PolygonXR
//
//  Created by QUINTON WALL on 6/12/24.
//
import Foundation
import Alamofire

class PolygonClient {
    static let shared = PolygonClient()
    
  
   
    private let baseURL = "https://api.polygon.io/v2"
    
    
    func fetchAggregates(symbol: String, multiplier: Int, timespan: String, from: String, to: String, sort: String, completion: @escaping (Result<StockData, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(getAPIKey())"
        ]
        
         let endpointURI = "/aggs/ticker"
        
        //polygon is case sensitive re ticker symbols. Always uppercase, just in case
        let aggsurl = baseURL + endpointURI+"/\(symbol.uppercased())/range/\(multiplier)/\(timespan)/\(from)/\(to)?sort=\(sort)"
    
        
        AF.request(aggsurl, headers: headers).responseDecodable(of: StockData.self) { response in
            switch response.result {
            case .success(let stockData):
                completion(.success(stockData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    // Polygon returns a unix timestamp in milliseconds. We need to convert this to a date before working with it.
    func convertUnixTimeToDateString(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime / 1000)
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM" // Specify desired date format
       let dateString = dateFormatter.string(from: date)
        
       return dateString
   }
    
    func getAPIKey() -> String {
        if let apiKey = Bundle.main.infoDictionary?["Polygon API Key"] as? String {
           return apiKey
        } else {
            print("No Polygon API key found. Add it to Info.plist")
            return ""
        }
    }
}

