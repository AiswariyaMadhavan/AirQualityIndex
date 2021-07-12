//
//  WeatherModel.swift
//  WebSocket
//
//  Created by Iswariya Madhavan on 11/07/21.
//

import Foundation
struct WeatherModel:  Decodable {
    var city: String!
    var aqi: Float!
}
