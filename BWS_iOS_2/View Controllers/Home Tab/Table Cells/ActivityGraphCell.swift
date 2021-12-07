//
//  ActivityGraphCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 07/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import Charts

class ActivityGraphCell: UITableViewCell {
    
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var lblSessionDesc: UILabel!
    @IBOutlet weak var lblSessionSubTitle: UILabel!
    @IBOutlet weak var lblSessionTitle: UILabel!
    @IBOutlet weak var imageSession: UIImageView!
    @IBOutlet weak var viewSession: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var activityData = [GraphAnalyticsModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data : [GraphAnalyticsModel]) {
        var graphValue = [GraphAnalyticsModel]()
        graphValue.append(contentsOf: data)
        
        let graphModel = GraphAnalyticsModel()
        graphModel.Day = ""
        graphModel.Time = ""
        graphValue.insert(graphModel, at: 0)
        graphValue.append(graphModel)
        
        activityData = graphValue
        
        configureChart()
    }
    
}

extension ActivityGraphCell : ChartViewDelegate {
    
    func configureChart() {
        chartView.delegate = self
        
        chartView.isUserInteractionEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.drawBarShadowEnabled = false
        chartView.backgroundColor = Theme.colors.off_white_F9F9F9
        
        // Legend
        let legend = chartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.yOffset = 10.0
        legend.xOffset = 0.0
        legend.yEntrySpace = 0.0
        
        // X Axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = Double(activityData.count - 1)
        xAxis.valueFormatter = self
        
        // Left Axis
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 12
        
        // Right Axis
        let rightAxis = chartView.rightAxis
        rightAxis.drawLabelsEnabled = false
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = 12
        
        setChart()
    }
    
    func setChart() {
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, data) in activityData.enumerated() {
            dataEntries.append(BarChartDataEntry(x:Double(index), y: data.Time.doubleValue))
        }
        
        let set1 = BarChartDataSet(entries: dataEntries, label: "Last 7 Days Time")
        set1.colors = [Theme.colors.blue_3E82BE]
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(Theme.fonts.montserratFont(ofSize: 14, weight: .regular))
        chartView.data = data
        
        chartView.fitBars = true
        chartView.xAxis.setLabelCount(activityData.count, force: true)
    }
    
}

extension ActivityGraphCell: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if Int(value) >= 0 && Int(value) < activityData.count {
            return activityData[Int(value)].Day
        }
        
        return ""
    }
    
}
