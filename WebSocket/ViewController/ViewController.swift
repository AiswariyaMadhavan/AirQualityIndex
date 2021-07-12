//
//  ViewController.swift
//  WebSocket
//
//  Created by Iswariya Madhavan on 11/07/21.
//

import UIKit

class ViewController: UIViewController {
    var weatherViewModel: WeatherViewModel?
    @IBOutlet weak var tblAQI: UITableView!
    var aqiResponse: Dictionary<String,Array<Float>>?
    var apiKeys: [String]?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel = WeatherViewModel.init()
        weatherViewModel?.viewModelDelegate = self
        Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(sendPing), userInfo: nil, repeats: true)
        weatherViewModel?.getAPIData()
        tblAQI.register(UINib.init(nibName: "AQITableViewCell", bundle: nil), forCellReuseIdentifier: "AQITableViewCell")
    }
    @objc func sendPing() {
        weatherViewModel?.getAPIData()
    }
}

extension ViewController: WeatherViewModelDelegate {
    func weatherQuality(weatherInfo: Dictionary<String,Array<Float>>?) {
        if let response = weatherInfo {
            aqiResponse = response
            apiKeys = Array(response.keys)
            DispatchQueue.main.async {
                self.tblAQI.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let aqiData = aqiResponse?.keys {
            return aqiData.count + 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQITableViewCell", for: indexPath) as? AQITableViewCell
        if indexPath.row == 0 {
            cell?.setData()
        }
        else {
            if let selectedData = apiKeys?[indexPath.row - 1],
               let selectedAQIValue = weatherViewModel?.getAPIHistory(city: selectedData),
               let lastUpdated = weatherViewModel?.getLastUpdateTime(city: selectedData){
                cell?.setData(city: selectedData, aqi: selectedAQIValue.first, lastUpdated: lastUpdated)
            }
            else {
                cell?.setData()
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedData = apiKeys?[indexPath.row - 1],
           let selectedAQIValue = weatherViewModel?.getAPIHistory(city: selectedData),
           let lastUpdated = weatherViewModel?.getUpdateTime(city: selectedData){
            let aqiHistory = AQIHistoryViewController.init(nibName: "AQIHistoryViewController", bundle: nil)
            self.navigationController?.pushViewController(aqiHistory, animated: false)
            aqiHistory.setData(dataPoints: lastUpdated, values: selectedAQIValue)
            print(selectedAQIValue)
            print(lastUpdated)
        }
    }
}
