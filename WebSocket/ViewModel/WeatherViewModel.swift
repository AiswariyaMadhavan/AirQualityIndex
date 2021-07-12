//
//  WeatherViewModel.swift
//  WebSocket
//
//  Created by Iswariya Madhavan on 11/07/21.
//

import Foundation

protocol WeatherViewModelDelegate {
    func weatherQuality(weatherInfo: Dictionary<String,Array<Float>>?)
}

class WeatherViewModel {
    let apiInterface = APIInterface()
    var viewModelDelegate: WeatherViewModelDelegate?
    var aqiHistory = Dictionary<String,Array<Float>>()
    var aqiUpdatedHistory = Dictionary<String,Array<Date>>()
    func getAPIData() {
        apiInterface.getWeatherQuality { [weak self] (response, error) in
            self?.updateAQIHistory(aqiInfo: response)
            self?.viewModelDelegate?.weatherQuality(weatherInfo: self?.aqiHistory)
        }
    }

    /******
     Returns AQI history for a selected City
     ******/
    func getAPIHistory(city: String) -> Array<Float>? {
        return aqiHistory[city]
    }
   
    /******
     Returns last updated time for a selected City
     ******/
    func getLastUpdateTime(city: String) -> String? {
        return getDifferenceInTime(updatedDate: (aqiUpdatedHistory[city]?.first)!)
    }
    
    /******
     Gets all timings for a selected city
     ******/
    func getUpdateTime(city: String) -> Array<String>? {
        if let arrayTime = aqiUpdatedHistory[city] {
            var formattedTime = Array<String>()
            for date in arrayTime {
                formattedTime.append(getTimeInHHMMFormat(updatedDate: date))
            }
            return formattedTime
        }
       return nil
    }
    
    private func updateAQIHistory(aqiInfo: [WeatherModel]?) {
        if let aqiResponse = aqiInfo {
            for value in aqiResponse {
                if var aqiHistoryValue = aqiHistory[value.city],
                   var aqiUpdatedHistoryValue = aqiUpdatedHistory[value.city] {
                    aqiHistoryValue.append(value.aqi)
                    aqiHistory[value.city] = aqiHistoryValue
                    if aqiHistoryValue.first != value.aqi {
                        aqiUpdatedHistoryValue.append(Date())
                        aqiUpdatedHistory[value.city] = aqiUpdatedHistoryValue

                    }
                    else {
                        print("no change for \(value.city)")
                    }
                }
                else {
                    aqiHistory[value.city] = [value.aqi]
                    aqiUpdatedHistory[value.city] = [Date()]
                }
                
            }
        }
    }
    
    func getDifferenceInTime(updatedDate: Date) -> String {
        let date = Date()
        let calendar = Calendar.current
        let hourDifference = calendar.dateComponents([.hour], from: updatedDate, to: date).hour
        let minuteDifference = calendar.dateComponents([.minute], from: updatedDate, to: date).minute ?? 0
        let secondDifference = calendar.dateComponents([.second], from: updatedDate, to: date).second ?? 0

        if hourDifference == 0 {
            if minuteDifference < 60 && minuteDifference > 0 && secondDifference < 60 {
                return "less than a minute"
            }
            else if secondDifference < 60 && secondDifference > 0 {
                return "less than a second"
            }
        }
       return getTimeInHHMMFormat(updatedDate: updatedDate)
    }
    
    func getTimeInHHMMFormat(updatedDate: Date) -> String{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: updatedDate)
        let minute = calendar.component(.minute, from: updatedDate)
        return String.init(format: "%d:%d", hour,minute)
    }
}
