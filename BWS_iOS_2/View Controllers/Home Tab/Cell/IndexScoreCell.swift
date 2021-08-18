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
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var viewJoinNow: UIView!
    @IBOutlet weak var viewGraph: BarChartView!
    
    @IBOutlet weak var viewScrore: UIView!
    @IBOutlet weak var lblIndexScore : UILabel!
    @IBOutlet weak var lblIndexScoreValue : UILabel!
    @IBOutlet weak var lblGrowth : UILabel!
    @IBOutlet weak var imgViewUpDown : UIImageView!
    @IBOutlet weak var progressView : UIProgressView!
    
    var graphValue = [GraphAnalyticsModel]()
//    let arrayDays = ["",
//                  "Mon", "Tue", "Wed",
//                  "Thu", "Fri", "Sat",
//                  "Sun",""]
    var months: [String]!
    
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
        lblGrowth.text = "\(scoreDiff)%"
        
        if ScoreIncDec.trim.count == 0 {
            lblGrowth.isHidden = true
            imgViewUpDown.isHidden = true
        } else if ScoreIncDec == "Increase" {
            lblGrowth.isHidden = false
            imgViewUpDown.isHidden = false
            
            lblGrowth.textColor = Theme.colors.red_CE5060
            imgViewUpDown.image = UIImage(named: "down_green")
            imgViewUpDown.tintColor = Theme.colors.red_CE5060
        } else {
            lblGrowth.isHidden = false
            imgViewUpDown.isHidden = false
            
            lblGrowth.textColor = Theme.colors.green_27B86A
            imgViewUpDown.image = UIImage(named: "up_green")
            imgViewUpDown.tintColor = Theme.colors.green_27B86A
        }
        
        progressView.progress = (indexScore.floatValue / 100)
        progressView.cornerRadius = 2.5
        progressView.clipsToBounds = true
        
        viewGraph.isHidden = true
        viewJoinNow.isHidden = true
        viewScrore.isHidden = false
        lblTitle.isHidden = false
        imgBanner.isHidden = true
    }
    
    func configureCheckIndexScoreCell() {
        lblTitle.text = "Your Mental health check up"
        
        viewGraph.isHidden = true
        viewJoinNow.isHidden = true
        viewScrore.isHidden = true
        lblTitle.isHidden = false
        imgBanner.isHidden = false
    }
    
    func configureJoinEEPCell() {
        viewGraph.isHidden = true
        viewJoinNow.isHidden = false
        viewScrore.isHidden = true
        lblTitle.isHidden = true
        imgBanner.isHidden = true
        
        viewJoinNow.layer.cornerRadius = 10
        viewJoinNow.clipsToBounds = true
    }
    
    func configureMyActivityCell(data : [GraphAnalyticsModel]) {
        lblTitle.text = "My activities"
        
        viewGraph.isHidden = false
        viewJoinNow.isHidden = true
        viewScrore.isHidden = true
        lblTitle.isHidden = false
        imgBanner.isHidden = true
        graphValue.removeAll()
        graphValue.append(contentsOf: data)
        
        
        
        months = ["", "mon", "tue", "wed", "thu", "fri", "sat", "sun",""]
        let unitsSold = [0.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0 , 0.0]
        setChart(dataPoints: months, values:graphValue)
    }
    
}

extension IndexScoreCell : ChartViewDelegate {
    
    func setChart(dataPoints: [String], values: [GraphAnalyticsModel]) {
        viewGraph.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
                
        for i in 0..<values.count {
            
            let dataEntry = BarChartDataEntry(x:values[i].Time.doubleValue, y: values[i].Time.doubleValue)
            dataEntries.append(dataEntry)
        }
                
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Last 7 days Time")
        let chartData = BarChartData(dataSet: chartDataSet)
        viewGraph.data = chartData
        
        let xAxis = viewGraph.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 8
        xAxis.valueFormatter = self
        
        let rightAxis = viewGraph.rightAxis
        rightAxis.drawLabelsEnabled = false
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = 0
        viewGraph.delegate = self
        viewGraph.backgroundColor = UIColor.white
        
        //legend
        let legend = viewGraph.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.yOffset = 10.0;
        legend.xOffset = 0.0;
        legend.yEntrySpace = 0.0;
            
    }
   
}

extension IndexScoreCell: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
    
}
