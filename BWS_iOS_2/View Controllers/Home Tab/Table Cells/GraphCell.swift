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
    
    @IBOutlet weak var chartView: LineChartView!
    
    var indexScores = [PastIndexScoreModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : [PastIndexScoreModel]) {
        indexScores.removeAll()
        indexScores.append(contentsOf: data)
        
        let indexScore = PastIndexScoreModel()
        indexScore.Month = "0"
        indexScore.MonthName = ""
        indexScore.IndexScore = "0"
        indexScores.insert(indexScore, at: 0)
        
        // fetchIndexScores()
        configureChart()
    }
    
    func fetchIndexScores() {
        indexScores.removeAll()
        
        for i in 1...4 {
            let indexScore = PastIndexScoreModel()
            indexScore.Month = "\(i)"
            indexScore.MonthName = "Month \(i)"
            indexScore.IndexScore = "\(i * 8)"
            indexScores.append(indexScore)
        }
    }
    
}

extension GraphCell : ChartViewDelegate {
    
    func configureChart() {
        chartView.delegate = self
        chartView.noDataText = "You data to display."
        
        chartView.isUserInteractionEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.backgroundColor = Theme.colors.off_white_F9F9F9
        
        chartView.extraTopOffset = 5
        chartView.extraLeftOffset = 0
        chartView.extraRightOffset = 20
        chartView.extraBottomOffset = 10
        
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
        legend.form = .line
        
        // X Axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.labelRotationAngle = 20
        xAxis.gridLineDashLengths = [5, 5]
        xAxis.gridLineDashPhase = 0
        xAxis.valueFormatter = self
        
        // Left Axis
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
        leftAxis.gridLineDashLengths = [5, 5]
        
        // Right Axis
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        rightAxis.drawLabelsEnabled = false
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = 100
        
        setChartData()
    }
    
    func setChartData() {
        var dataEntries = [ChartDataEntry]()
        
        for (index, data) in indexScores.enumerated() {
            let yValue = (data.IndexScore as NSString).doubleValue
            dataEntries.append(ChartDataEntry(x: Double(index), y: yValue))
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Past Wellness Score")
        setupDataSet(dataSet)
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        
        let chartData = LineChartData(dataSet: dataSet)
        chartView.data = chartData
        
        chartView.xAxis.setLabelCount(dataEntries.count, force: true)
    }
    
    func setupDataSet(_ dataSet: LineChartDataSet) {
        dataSet.lineDashLengths = [5, 2.5]
        dataSet.highlightLineDashLengths = [5, 2.5]
        dataSet.setColor(.black)
        dataSet.setCircleColor(.black)
        dataSet.lineWidth = 1
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = false
        dataSet.formLineDashLengths = [5, 2.5]
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
        
        dataSet.valueFont = Theme.fonts.montserratFont(ofSize: 10, weight: .bold)
        dataSet.valueFormatter = self
        dataSet.drawValuesEnabled = true
        
        chartView.setNeedsDisplay()
    }
    
}

extension GraphCell: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if Int(value) >= 0 && Int(value) < indexScores.count {
            return indexScores[Int(value)].MonthName
        }
        
        return ""
    }
    
}

extension GraphCell : IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value))"
    }
    
}
