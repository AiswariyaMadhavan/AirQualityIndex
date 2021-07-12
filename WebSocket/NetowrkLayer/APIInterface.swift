//
//  NetworkManager.swift
//  WebSocket
//
//  Created by Iswariya Madhavan on 11/07/21.
//

import Foundation

class APIInterface {
    var weatherObject: [WeatherModel]?
    var webSocketTask: URLSessionWebSocketTask!
    init() {
    }
    
    func getWeatherQuality(completion: @escaping(_ response: [WeatherModel]?, _ error: Error?)-> Void) {
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://city-ws.herokuapp.com/")!)
        webSocketTask.resume()
        webSocketTask.receive {  [weak self] (response) in
            print(response)
            switch response {
            case .success(let message):
                switch message {
                case .data(let _):
                    completion(nil,nil)
                case .string(let title):
                    let responseData = title.data(using: .utf8)
                    let decoder = JSONDecoder()
                    self?.weatherObject = try! decoder.decode([WeatherModel].self, from: responseData!)
                    completion((self?.weatherObject)!,nil)
                default:
                    print("no case")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
