//
//  AQIHistoryViewController.swift
//  WebSocket
//
//  Created by Iswariya Madhavan on 12/07/21.
//

import UIKit
import Charts
class AQIHistoryViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView?
    var updatedTime: [String]!
    var aqiValues: [Float]!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart()
    }

    func setData(dataPoints: [String], values: [Float]) {
        self.updatedTime = dataPoints
        self.aqiValues = values
    }
    func setChart() {
        var dataEntries: [BarChartDataEntry] = []
                                
        for i in 0..<updatedTime.count {
            
            let dataEntry = BarChartDataEntry.init(x: Double(i), y: Double(aqiValues[i]))
            dataEntries.append(dataEntry)
        }
                
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "AQI History")
        barChartView?.data = BarChartData.init(dataSet: chartDataSet)
       }
}
