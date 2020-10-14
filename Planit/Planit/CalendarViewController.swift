//
//  CalendarViewController.swift
//  Planit
//
//  Created by Jiye Choi on 10/13/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate,FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var calendar: FSCalendar!
    let formatter = DateFormatter()
    
    @IBOutlet weak var eventTable: UITableView!
    let eventArray = ["2020-10-01 hw2","2020-10-14 Exam", "2020-10-28 D-day!"]
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.todayColor = UIColor.black
        calendar.appearance.todaySelectionColor = UIColor.red
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.subtitleSelectionColor = UIColor.red
        formatter.dateFormat = "yyyy-MM-dd"
        
        eventTable.delegate = self
        eventTable.dataSource = self
    }
    
    // -------- Calendar Callback Functions -------------------------------
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " selected")
    }
    
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " deselected")
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        switch formatter.string(from: date) {
        case formatter.string(from : Date()):
            return "Today"
        case "2020-10-01":
            return "hw2"
        case "2020-10-14":
            return "Exam"
        case "2020-10-28":
            return "D-day"
        default:
            return nil
        }
    }
    // ---------------------------------------------------------------------
    
    // -------Event List Table Funcs ---------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // To define how many rows are needed
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuns whenever the table view needs to put data in its rows
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = eventArray[indexPath.row]
        return cell!
    }
    
}