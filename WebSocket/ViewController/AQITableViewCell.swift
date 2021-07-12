//
//  AQITableViewCell.swift
//  WebSocket
//
//  Created by Iswariya Madhavan on 12/07/21.
//

import UIKit

class AQITableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCurrentAQI: UILabel!
    @IBOutlet weak var lblLastUpdate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(city: String? = nil, aqi: Float? = nil, lastUpdated: String? = nil) -> Void {
        if let cityValue = city,
           let aqiValue = aqi,
           let lastUpdatedValue = lastUpdated {
            self.lblCity.text = cityValue
            self.lblCurrentAQI.text = String.init(format: "%.2f", aqiValue)
            customizeUI(apiValue: aqiValue)
            self.lblLastUpdate.text = lastUpdatedValue
        }
        else {
            self.lblCity.text = "City"
            self.lblCurrentAQI.text = "Current AQI"
            self.lblLastUpdate.text = "Last updated"
        }
        
    }
    
    private func customizeUI(apiValue: Float) {
        if apiValue <= 50 && apiValue > 0 {
            self.backgroundColor = .systemGreen
        }
        else if apiValue <= 100 && apiValue > 50 {
            self.backgroundColor = .green
        }
        else if apiValue <= 200 && apiValue > 100 {
            self.backgroundColor = .systemYellow
        }
        else if apiValue <= 300 && apiValue > 200 {
            self.backgroundColor = .orange
        }
        else if apiValue <= 400 && apiValue > 300 {
            self.backgroundColor = .red
        }
        else {
            self.backgroundColor = .systemRed
        }
    }
}
