//
//  CalendarViewController.swift
//  Planit
//
//  Created by Jiye Choi on 10/13/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    let formatter = DateFormatter()
    let today = Date()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year_label: UILabel!
    @IBOutlet weak var month_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        //To display year and month label when it loaded
        calendarView.visibleDates { visibleDates in self.setHeaders(from: visibleDates)}
        calendarView.scrollToDate(Date(), animateScroll: false)
        
    }
    
    // ------------------ Calendar -----------------
 
    // JTAppleCalendarViewDelegate
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calCell", for: indexPath) as! DateCell
        configureCell(view: cell, cellState: cellState)
        return cell
    }
    
    // JTAppleCalendarViewDataSource
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let startCalendar = formatter.date(from: "01/01/2020")!
        let endCalendar = formatter.date(from: "12/31/2022")!
        return ConfigurationParameters(startDate: startCalendar, endDate: endCalendar)
    }
    
    func setHeaders(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.year_label.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "MMMM"
        self.month_label.text = self.formatter.string(from: date)
    }
    
    // configure cells 
    func configureCell(view: JTAppleCell?, cellState: CellState){
        guard let cell = view as? DateCell  else { return }
        cell.dayLabel.text = cellState.text
        
        // set cell text color
        self.formatter.dateFormat = "yyyy/MM/dd"
        let today_str = self.formatter.string(from: today)
        let currCell_str = self.formatter.string(from: cellState.date)
        
        if today_str == currCell_str {
            //change the today date color to blue
            cell.dayLabel.textColor = UIColor.blue
        }else {
            // if it's not today, selected cell = black, otherwise = white
            if cellState.isSelected {
                cell.dayLabel.textColor = UIColor.black
            }else{
                cell.dayLabel.textColor = UIColor.white
            }
        }
        
        // hide past month, next month
        if cellState.dateBelongsTo == .thisMonth{
            cell.isHidden = false
        }else{
            cell.isHidden = true
        }
        
    }
    
}


