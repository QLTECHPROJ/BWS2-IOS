//
//  IndexScoreCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 26/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit
import Charts

class IndexScoreCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewCheckWellnessScore: UIView!
    @IBOutlet weak var viewJoinNow: UIView!
   
    @IBOutlet weak var chartView: BarChartView!
    
    @IBOutlet weak var viewScrore: UIView!
    @IBOutlet weak var lblIndexScore : UILabel!
    @IBOutlet weak var lblIndexScoreValue : UILabel!
    @IBOutlet weak var lblGrowth : UILabel!
    @IBOutlet weak var imgViewUpDown : UIImageView!
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var lblIndexScoreDescription : UILabel!
    
    let days = ["",
                "Mon", "Tue", "Wed",
                "Thu", "Fri", "Sat",
                "Sun",
                ""]
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    let floatValue: [CGFloat] = [4,4]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureIndexScoreCell(IndexScoreDiff : String, ScoreIncDec : String) {
        lblTitle.text = "Wellness Score"
        
        let indexScore = CoUserDataModel.currentUser?.indexScore ?? "0"
        lblIndexScore.text = indexScore
        lblIndexScoreValue.text = CoUserDataModel.currentUser?.ScoreLevel ?? "Normal"
        
        let scoreDiff = Int((IndexScoreDiff as NSString).doubleValue.rounded())
        lblGrowth.text = "\(scoreDiff)"
        
        if ScoreIncDec.trim.count == 0 {
            lblGrowth.isHidden = true
            imgViewUpDown.isHidden = true
        } else if ScoreIncDec == "Increase" {
            lblGrowth.isHidden = false
            imgViewUpDown.isHidden = false
            
            lblGrowth.textColor = Theme.colors.green_27B86A
            imgViewUpDown.image = UIImage(named: "up_green")
            imgViewUpDown.tintColor = Theme.colors.green_27B86A
        } else {
            lblGrowth.isHidden = false
            imgViewUpDown.isHidden = false
            
            lblGrowth.textColor = Theme.colors.red_CE5060
            imgViewUpDown.image = UIImage(named: "down_green")
            imgViewUpDown.tintColor = Theme.colors.red_CE5060
        }
        
        progressView.progress = (indexScore.floatValue / 100)
        progressView.cornerRadius = 2.5
        progressView.clipsToBounds = true
        
        chartView.isHidden = true
        viewJoinNow.isHidden = true
        viewScrore.isHidden = false
        lblTitle.isHidden = false
        viewCheckWellnessScore.isHidden = true
    }
    
    func configureCheckIndexScoreCell() {
        lblTitle.text = "Your Mental health check up"
        
        chartView.isHidden = true
        viewJoinNow.isHidden = true
        viewScrore.isHidden = true
        lblTitle.isHidden = false
        viewCheckWellnessScore.isHidden = false
    }
    
    func configureJoinEEPCell() {
        chartView.isHidden = true
        viewJoinNow.isHidden = false
        viewScrore.isHidden = true
        lblTitle.isHidden = true
        viewCheckWellnessScore.isHidden = true
        
        viewJoinNow.layer.cornerRadius = 10
        viewJoinNow.clipsToBounds = true
    }
    
    func configureMyActivityCell(data : [GraphAnalyticsModel]) {
        lblTitle.text = "My activities"
        
        chartView.isHidden = false
        viewJoinNow.isHidden = true
        viewScrore.isHidden = true
        lblTitle.isHidden = false
        viewCheckWellnessScore.isHidden = true
        
        var graphValue = [GraphAnalyticsModel]()
        graphValue.append(contentsOf: data)
        
        let graphModel = GraphAnalyticsModel()
        graphModel.Day = ""
        graphModel.Time = ""
        graphValue.insert(graphModel, at: 0)
        graphValue.append(graphModel)
        
        barChartUpdate(values: graphValue)
    }
    
}

extension IndexScoreCell : ChartViewDelegate {
    
    func barChartUpdate(values: [GraphAnalyticsModel]) {
        chartView.delegate = self
        
        chartView.isUserInteractionEnabled = false
        // chartView.rightAxis.enabled = false
        chartView.chartDescription?.enabled = false
        chartView.maxVisibleCount = values.count
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
        xAxis.axisMaximum = 8
        xAxis.valueFormatter = self
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 12
        
        let rightAxis = chartView.rightAxis
        rightAxis.drawLabelsEnabled = false
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = 12
        
        setChart(values: values)
    }
    
    func setChart(values: [GraphAnalyticsModel]) {
        chartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for (index,data) in values.enumerated() {
            let dataEntry = BarChartDataEntry(x:Double(index), y: data.Time.doubleValue)
            dataEntries.append(dataEntry)
        }
        
        let set1 = BarChartDataSet(entries: dataEntries, label: "Last 7 Days Time")
        set1.colors = [Theme.colors.blue_3E82BE]
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(Theme.fonts.montserratFont(ofSize: 14, weight: .regular))
        chartView.data = data
        chartView.fitBars = true
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
        chartView.setNeedsDisplay()
    }
    
}

extension IndexScoreCell: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[Int(value) % days.count]
    }
    
}

