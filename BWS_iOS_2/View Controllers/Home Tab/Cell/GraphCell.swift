//
//  PlayerBannerCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 26/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit
import Charts

class GraphCell: UITableViewCell {
    
    @IBOutlet weak var chartView: BarChartView!
    
    var indexScores = [PastIndexScoreModel]()
    let months = ["",
                  "Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : [PastIndexScoreModel]) {
        indexScores.removeAll()
        indexScores.append(contentsOf: data)
        // fetchIndexScores()
        barChartUpdate()
    }
    
    func fetchIndexScores() {
        indexScores.removeAll()
        
        for i in 1...4 {
            let indexScore = PastIndexScoreModel()
            indexScore.Month = "\(i)"
            indexScore.IndexScore = "\(i * 8)"
            indexScores.append(indexScore)
        }
    }
    
}

extension GraphCell : ChartViewDelegate {
    
    func barChartUpdate() {
        chartView.delegate = self
        
        chartView.isUserInteractionEnabled = false
        chartView.rightAxis.enabled = false
        chartView.chartDescription?.enabled = false
        chartView.maxVisibleCount = indexScores.count
        chartView.drawBarShadowEnabled = false
        chartView.backgroundColor = Theme.colors.off_white_F9F9F9
        
        //legend
        let legend = chartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.yOffset = 10.0;
        legend.xOffset = 0.0;
        legend.yEntrySpace = 0.0;
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 12
        xAxis.valueFormatter = self
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
        
        setChart()
    }
    
    func setChart() {
        var dataEntries = [BarChartDataEntry]()
        
        for data in indexScores {
            let xValue = (data.Month as NSString).doubleValue
            let yValue = (data.IndexScore as NSString).doubleValue
            
            let dataEntry = BarChartDataEntry(x: xValue, y: yValue)
            dataEntries.append(dataEntry)
        }
        
        let set1 = BarChartDataSet(entries: dataEntries, label: "Past Index Score")
        set1.colors = [Theme.colors.red_CE5060]
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(Theme.fonts.montserratFont(ofSize: 10, weight: .regular))
        chartView.data = data
        chartView.fitBars = true
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
        chartView.setNeedsDisplay()
    }
    
}

extension GraphCell: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
    
}
