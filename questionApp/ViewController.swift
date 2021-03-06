//
//  ViewController.swift
//  questionApp
//
//  Created by Brown Magic on 6/8/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import Charts


class ViewController: BNUIViewController {

  @IBOutlet weak var subView: UIView!
  @IBOutlet weak var barChartView: HorizontalBarChartView!
  @IBOutlet weak var rangeChart: BNTestRangeChartView!
  
  var months: [String]?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    months = ["Jan"]
    let unitsSold = [8.0]
    
    setChart(months!, values: unitsSold)
    rangeChart.config(startMonth: 0, endMonth: 12, successAgeInMonths: 1, babyAgeInMonths: 8, babyName: "BabyNameGoesHere")
    
    //check all fonts
    /*
    for family in UIFont.familyNames() {
      print(family)
      for name in UIFont.fontNamesForFamilyName(family as! String) {
        print(name)
      }
    }
    */
  }

  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setChart(dataPoints: [String], values: [Double]) {
    // customize chart before setting data
    barChartView.noDataText = "No data to show you"
    barChartView.drawGridBackgroundEnabled = false
    barChartView.drawBordersEnabled = false
    barChartView.descriptionText = ""
    barChartView.legend.enabled = false
    barChartView.xAxis.enabled = false
    
    barChartView.autoScaleMinMaxEnabled = false
    
    var leftYAxis = barChartView.leftAxis
    leftYAxis.enabled = false
    var rightYAxis = barChartView.rightAxis
    rightYAxis.drawAxisLineEnabled = false
//    rightYAxis.axisMaximum = 40
    rightYAxis.customAxisMin = 0
    rightYAxis.customAxisMax = 16
    rightYAxis.labelCount = 2
    leftYAxis.spaceBottom = 0.2
    rightYAxis.spaceBottom = 0.2
    leftYAxis.spaceTop = 0.2
    rightYAxis.spaceTop = 0.2
//    rightYAxis.axisMinimum = 10
    // formatter
    var formatter:NSNumberFormatter = NSNumberFormatter()
    formatter.maximumFractionDigits = 1
    formatter.positiveSuffix = " mo."
    rightYAxis.valueFormatter = formatter
    
    // fonts
    rightYAxis.labelFont = UIFont(name: kOmnesFontMedium, size: 17)!
    rightYAxis.labelTextColor = kGrey
    
    // set limit lines
    var babyAgeLimitLine = ChartLimitLine(limit: 9.0, label: "Your Baby")
    babyAgeLimitLine.valueFont = UIFont(name: kOmnesFontSemiBold, size: 16)!
    babyAgeLimitLine.valueTextColor = kOrange
    babyAgeLimitLine.lineColor = kOrange
    babyAgeLimitLine.lineWidth = 5.0
    babyAgeLimitLine.lineDashLengths = [12]
    rightYAxis.addLimitLine(babyAgeLimitLine)
    
    // data should be set after customizing chart
    var dataEntries: [BarChartDataEntry] = []
    
    for i in 0..<dataPoints.count {
      let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
      dataEntries.append(dataEntry)
    }
    
    let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
    chartDataSet.drawValuesEnabled = false
    let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
    barChartView.data = chartData
    
    barChartView.setExtraOffsets(left: 30, top: 0, right: 30, bottom: 0)
    
    barChartView.notifyDataSetChanged()
    
  }
  
  func monthlyAxisFormatter() {
    
  }

}

