//
//  ViewController.swift
//  Planit
//
//  Created by Pete Walker on 10/13/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import UIKit

/* This is the main view controller */
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    let formatter = DateFormatter()
    let today = Date()
    var db:DBManager = DBManager() // connect database
    let sg:ScheduleGenerator = ScheduleGenerator()
    
    // UIs
    @IBOutlet weak var todayTaskTableView: UITableView!
    @IBOutlet weak var taskTable: UITableView! // task table view

    
    let taskCellId = "cellID" // identifier for each cell
    var task_list:[Task] = [] // to store data from the database
    var today_todo_list:[Task] = []
    let todayCellId = "todayCell"
    
    var dataArr:[String]? = []
    var text_selectedCell:String? = ""
    var sorted_task_list:[Task]=[]
    var calendar:[String:[Task]] = [:]
    
    // setup
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.delegate = self
        taskTable.dataSource = self
        taskTable.register(UITableViewCell.self, forCellReuseIdentifier: taskCellId)
        self.task_list = db.readData() // read data from the DB and store them in the list
        sorted_task_list = sg.generate(task_list: task_list)
        prepareRefresh() // For refresh the table view
        
        todayTaskTableView.delegate = self
        todayTaskTableView.dataSource = self
        todayTaskTableView.register(UITableViewCell.self, forCellReuseIdentifier: todayCellId)
        calendar = getCalendarTasks(tasks: sorted_task_list) // getting calendar tasks
        today_todo_list = getTodaysTask(calendar: calendar) // getting today's tasks

    }
    
    func getCalendarTasks(tasks:[Task])->[String:[Task]]{
        /*
         This function is to get tasks for each date since each task has time interval from a start date to a deadline, on a date between these two dates, the calendar should display the task as the todo list.
         */
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        var calendar:[String:[Task]] = [:]

        for task in tasks {
            let deadline = String(task.deadline.split(separator: " ")[0])
            let dateString = String(formatter.string(from:task.start_date).split(separator: " ")[0])
            var date = formatter.date(from: dateString)!

            while(date <= formatter.date(from: deadline)!){

                if(calendar.contains(where: {$0.key == String(formatter.string(from:date).split(separator: " ")[0])})){
                    var list = calendar[String(formatter.string(from:date).split(separator: " ")[0])]
                    list?.append(task)
                    calendar[String(formatter.string(from:date).split(separator: " ")[0])] = list
                }else{
                    var list:[Task] = []
                    list.append(task)
                    calendar[String(formatter.string(from:date).split(separator: " ")[0])] = list
                }
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            }
        }
//        for (key,value) in calendar{
//            for task in value{
//                print("\(key) and \(task.title)")
//            }
//        }
        return calendar
    }
    
    func getTodaysTask(calendar:[String:[Task]]) -> [Task]{
        /* this function is to get tasks for current date */
        var today_task_list:[Task] = []
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let todayString = String(formatter.string(from: today).split(separator: " ")[0])
        if(calendar.contains(where: {$0.key == todayString})){
            today_task_list = calendar[todayString]!
        }
        return today_task_list
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // to identify the segue named "firstLink" (main - calendar) and follow that segue to open another view.
        performSegue(withIdentifier: "firstLink", sender: self)
    }
    
    func prepareRefresh() {
        // initialize refresh controller
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(updateTable(refreshController:)), for: .valueChanged)
        refreshController.attributedTitle = NSAttributedString(string: "refresh")
        if #available(iOS 10.0, *){
            taskTable.refreshControl = refreshController
        }else {
            taskTable.addSubview(refreshController)
        }
    }
    
 
    @objc func updateTable(refreshController : UIRefreshControl){
        // when user refreshes the table, it read the DB and reload for update
        refreshController.endRefreshing()
        task_list = db.readData()
        sorted_task_list = sg.generate(task_list: task_list)
        calendar = getCalendarTasks(tasks: sorted_task_list)
        today_todo_list = getTodaysTask(calendar: calendar)
        taskTable.reloadData()
        todayTaskTableView.reloadData()
    }
    
    @IBAction func SettingEvent(_ sender: Any) {
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        if let selectedCells = taskTable.indexPathsForSelectedRows{
            for indexPath in selectedCells{
                let selectedTask = sorted_task_list[indexPath.row]
                db.deleteById(id: selectedTask.id)
                task_list = db.readData()
                sorted_task_list = sg.generate(task_list: task_list)
                taskTable.reloadData()
            }
        }else {
            print("it's empty")
        }
    }
    
    /*----------Handling TableView ---------*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // To define how many rows are needed
        if tableView == self.taskTable {
            return task_list.count
        }else{
            return today_todo_list.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuns whenever the table view needs to put data in its rows
        var cell:UITableViewCell
        var title:String
        var deadline:String
        var workload:Int
        
        if(tableView == self.taskTable){
            cell = tableView.dequeueReusableCell(withIdentifier: taskCellId)!
            title = sorted_task_list[indexPath.row].title
            deadline = sorted_task_list[indexPath.row].deadline
            workload = sorted_task_list[indexPath.row].workload
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: todayCellId)!
            title = today_todo_list[indexPath.row].title
            deadline = today_todo_list[indexPath.row].deadline
            workload = today_todo_list[indexPath.row].workload
        }
        
        let string = String(indexPath.row) + " " + title + " " + deadline + " " + String(workload)
        cell.textLabel?.text =  string
        
        return cell
    }
    

    /*------------------------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass sorted list and events to the calendarview 
        if segue.destination is CalendarViewController {
            let vc = segue.destination as? CalendarViewController
            vc?.task_list = sorted_task_list
            vc?.event_dict = calendar
        }
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue){
        
    }
    
}

