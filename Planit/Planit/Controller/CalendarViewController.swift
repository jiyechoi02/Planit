//
//  CalendarViewController.swift
//  Planit
//
//  Created by Jiye Choi on 10/13/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewTableCell: UITableViewCell{

    @IBOutlet weak var workloadLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}
class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    // shared variables
    let formatter = DateFormatter()
    let today = Date()

    // calendar variables & UIs
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year_label: UILabel!
    @IBOutlet weak var month_label: UILabel!
    
    // event table view variables & UIs
    let eventCellID = "eventCell"
    var task_list:[Task] = []
    var event_dict:[String:[Task]] = [:]
    var current_date_event_list:[Task] = []
    @IBOutlet weak var event_label: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
        
        //To display year and month label when it loaded
        calendarView.visibleDates { visibleDates in self.setHeaders(from: visibleDates)}
        calendarView.scrollToDate(Date(), animateScroll: false)
        for (key,val) in event_dict{
            print("\(key) : \(val)")
        }
    }
    
    // ------------------ Calendar -----------------
    // setting year, month labels
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
        self.formatter.dateFormat = "MM/dd/yy"
        let today_str = self.formatter.string(from: today)
        let currCell_str = self.formatter.string(from: cellState.date)
        
        // configure today's date 
        if today_str == currCell_str {
            //change the today date color to blue
            cell.dayLabel.textColor = UIColor.blue
            cell.todayView.isHidden = false
        }else{
            cell.todayView.isHidden = true
        }
        
        // hide past month, next month
        if cellState.dateBelongsTo == .thisMonth{
            cell.isHidden = false
        }else{
            cell.isHidden = true
        }
         
        // handle events
        handleEvents(cell: cell, cellState: cellState)
        // configure selection Event
        selectionEvent(cell: cell, cellState: cellState)

    }
    
    func selectionEvent(cell: DateCell, cellState: CellState){
        /* This function is to check if the date is selected, then, change some uis, and also get event list on that date.*/
        if cellState.isSelected {
            cell.dayLabel.textColor = UIColor.black
            cell.selectView.isHidden = false
            if(!cell.todayView.isHidden) {
                cell.todayView.isHidden = true
            }
            event_label.text = formatter.string(from: cellState.date)
            if (event_dict.contains{ $0.key == formatter.string(from: cellState.date)}){
                current_date_event_list = []
                current_date_event_list = event_dict[formatter.string(from: cellState.date)]!
            }else{
                current_date_event_list = []
            }
        }else{
            cell.dayLabel.textColor = UIColor.white
            cell.selectView.isHidden = true
            event_label.text = "Tasks on " + formatter.string(from: today)
            if (event_dict.contains{ $0.key == formatter.string(from: today)}){
                current_date_event_list = []
                current_date_event_list = event_dict[formatter.string(from: today)]!
            }
        }
        eventTableView.reloadData()
    }
    
    func handleEvents(cell: DateCell, cellState: CellState){
        /* this function is to display 'event dot' on dates if they have tasks to do */
        formatter.dateFormat = "MM/dd/yy"
        //print(formatter.string(from: cellState.date))
       // print("events \(cellState.date) : \(event_dict[formatter.string(from: cellState.date)])")
        if (event_dict.contains{ $0.key == formatter.string(from: cellState.date)}){
            cell.eventdotView.isHidden = false
        }else{
            cell.eventdotView.isHidden = true
        }
    }
    // JTAppleCalendarViewDataSource
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let startCalendar = formatter.date(from: "01/01/20")!
        let endCalendar = formatter.date(from: "12/31/22")!
        return ConfigurationParameters(startDate: startCalendar, endDate: endCalendar)
    }
    
    // JTAppleCalendarViewDelegate
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calCell", for: indexPath) as! DateCell
        configureCell(view: cell, cellState: cellState)
        return cell
    }
    // handle scroll calendar
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setHeaders(from: visibleDates)
    }
    // handle selecting dates
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    // handle deselecting dates
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    // --------------- Event List table view ------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return current_date_event_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellID) as! CalendarViewTableCell
//        if(cell == nil){
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: eventCellID) as! TaskCell
//        }
       // cell.textLabel?.text = current_date_event_list[indexPath.row].title
        cell.titleLabel?.text = current_date_event_list[indexPath.row].title
        cell.workloadLabel?.text = String(format: "%.2f",current_date_event_list[indexPath.row].amount_of_a_day)
       // var deadline = current_date_event_list[indexPath.row].deadline
    //    cell.calDeadlineView?.isHidden = !current_date_event_list[indexPath.row].isDeadlineComing(deadline: deadline)
        
        return cell
    }
    
    func parsingData(task_list: [Task]) -> [String:[Task]] {
        var event_dict:[String:[Task]] = [:]
        formatter.dateFormat = "MM/dd/yy"
        for task in task_list{
            let str = task.deadline
            if(event_dict.contains{ $0.key == str.split(separator: " ")[0]}){
                event_dict[String(str.split(separator: " ")[0])]?.append(task)
            }else{
                var list:[Task] = []
                list.append(task)
                event_dict[String(str.split(separator: " ")[0])] = list
                
            }
        }
        return event_dict
    }

}


