//
//  ViewController.swift
//  Planit
//
//  Created by Pete Walker on 10/13/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workload:UILabel!
    @IBOutlet weak var deadlineLabel:UILabel!
}
/* This is the main view controller */
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    let formatter = DateFormatter()
    let today = Date()
    var db:DBManager = DBManager() // connect database
    let sg:ScheduleGenerator = ScheduleGenerator()
    
    // UIs
 //   @IBOutlet weak var todayTaskTableView: UITableView!
    @IBOutlet weak var taskTable: UITableView! // task table view

    let user = "Jiye"
    let taskCellId = "cell" // identifier for each cell
    var task_list:[Task] = [] // to store data from the database
    var today_todo_list:[Task] = []
    let todayCellId = "todayCell"
    
    var dataArr:[String]? = []
    var text_selectedCell:String? = ""
    var sorted_task_list:[Task]=[]
    var calendar:[String:[Task]] = [:]
    
    //user Setting
    var max_hrs:Float = 5.0
    var min_hrs:Float = 0.5
    var late_days:Float = 3.0
    var map:[String:Float] = [:]
    
    // setup
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.delegate = self
        taskTable.dataSource = self
        taskTable.register(TaskTableViewCell.self, forCellReuseIdentifier: taskCellId)
        self.task_list = db.readData() // read data from the DB and store them in the list
        sorted_task_list = sg.generate(task_list: task_list, min_work_per_day: min_hrs, max_work_per_day: max_hrs, max_late_days: late_days)
        prepareRefresh() // For refresh the table view
        
      //  todayTaskTableView.delegate = self
      //  todayTaskTableView.dataSource = self
       // todayTaskTableView.register(TaskCell.self, forCellReuseIdentifier: taskCellId)
        calendar = getCalendarTasks(tasks: sorted_task_list) // getting calendar tasks
        today_todo_list = getTodaysTask(calendar: calendar) // getting today's tasks
        setUserSetting(name: user)
        db.readUserData(name:"Jiye")
    }
    func setUserSetting(name:String = "Jiye", min_hrs:Float = 1, max_hrs:Float = 5, max_late_days:Float = 3){
        if db.insertUserData(name: name, min_hrs: min_hrs, max_hrs: max_hrs, max_late_days: max_late_days) == 1 {
            self.map = db.readUserData(name:name)
            self.min_hrs = self.map["min_hrs"]!
            self.max_hrs = self.map["max_hrs"]!
            self.late_days = self.map["late_days"]!
        }
    }
    
    func getCalendarTasks(tasks:[Task])->[String:[Task]]{
        /*
         This function is to get tasks for each date since each task has time interval from a start date to a deadline, on a date between these two dates, the calendar should display the task as the todo list.
         */
        formatter.dateFormat = "MM/dd/yy"
       // formatter.timeStyle = .none
        
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
        refreshController.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        refreshController.attributedTitle = NSAttributedString(string: "refresh")
        if #available(iOS 10.0, *){
            taskTable.refreshControl = refreshController
        }else {
            taskTable.addSubview(refreshController)
        }
    }
    
 
    @objc func refreshTable(refreshController : UIRefreshControl){
        // when user refreshes the table, it read the DB and reload for update
        refreshController.endRefreshing()
        update()
    }
    func update(){
        task_list = db.readData()
        sorted_task_list = sg.generate(task_list: task_list, min_work_per_day: min_hrs, max_work_per_day: max_hrs, max_late_days: late_days)
        calendar = getCalendarTasks(tasks: sorted_task_list)
        today_todo_list = getTodaysTask(calendar: calendar)
        taskTable.reloadData()
     //   todayTaskTableView.reloadData()
    }
    
    func updateUserSetting(){
        self.map = db.readUserData(name: "Jiye")
        self.min_hrs = self.map["min_hrs"]!
        self.max_hrs = self.map["max_hrs"]!
        self.late_days = self.map["late_days"]!
        
    }
    @IBAction func SettingEvent(_ sender: Any) {
    }
    
//    @IBAction func deleteEvent(_ sender: Any) {
//        if let selectedCells = taskTable.indexPathsForSelectedRows{
//            for indexPath in selectedCells{
//                let selectedTask = sorted_task_list[indexPath.row]
//                db.deleteById(id: selectedTask.id)
//                update()
//
//            }
//        }else {
//            print("it's empty")
//        }
//    }
//
    
    /*----------Handling TableView ---------*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // To define how many rows are needed
        return task_list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuns whenever the table view needs to put data in its rows
       
        var title:String
        var deadline:String
        var workload:Float

       // if(tableView == self.taskTable){
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellId, for: indexPath) as! TaskTableViewCell
        title = sorted_task_list[indexPath.row].title
        deadline = sorted_task_list[indexPath.row].deadline
        workload = Float(sorted_task_list[indexPath.row].workload)
        
        cell.titleLabel?.text = title
        cell.workload?.text = String(workload)
     //   cell.deadlineView?.isHidden = !sorted_task_list[indexPath.row].isDeadlineComing(deadline: deadline)
        cell.deadlineLabel?.text = deadline
        //isDeadlineComing(deadline: deadline)
        return cell
//        }
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: todayCellId, for: indexPath) as! TaskCell
//            title = today_todo_list[indexPath.row].title
//            deadline = today_todo_list[indexPath.row].deadline
//            workload = today_todo_list[indexPath.row].amount_of_a_day
//            
////            cell.todayTitle?.text = title
////            cell.todayWorkload?.text = String(format: "%.2f",workload)
////            cell.todayDeadlineView?.isHidden = !today_todo_list[indexPath.row].isDeadlineComing(deadline: deadline)
////            cell.todayDeadlineLabel?.text = deadline
//         //   isDeadlineComing(deadline: deadline)
//            return cell
//        }

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
          //  tableView.remove(at: indexPath.row)
            let selectedTask = sorted_task_list[indexPath.row]
            db.deleteById(id: selectedTask.id)
            task_list = db.readData()
            sorted_task_list = sg.generate(task_list: task_list, min_work_per_day: min_hrs, max_work_per_day: max_hrs, max_late_days: late_days)
            calendar = getCalendarTasks(tasks: sorted_task_list)
            today_todo_list = getTodaysTask(calendar: calendar)
            tableView.deleteRows(at: [indexPath], with: .fade)
            taskTable.reloadData()
     //       todayTaskTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == self.taskTable {
        self.performSegue(withIdentifier: "editTask", sender: indexPath.row)
//        }
       // self.performSegue(withIdentifier: "editTask", sender: indexPath.row)
    }
    /*------------------------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass sorted list and events to the calendarview 
        if segue.destination is CalendarViewController {
            let vc = segue.destination as? CalendarViewController
            vc?.task_list = sorted_task_list
            vc?.event_dict = calendar
        }else if segue.destination is EditTaskViewController {
            
            if let index = taskTable.indexPathForSelectedRow {
                let vc = segue.destination as? EditTaskViewController
                let row = index.row
                vc?.task = sorted_task_list[row]
            }
            
        }else {
            let vc = segue.destination as? TaskViewController
            vc?.task_list = sorted_task_list
        }
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue){
        taskTable.reloadData()
// //       todayTaskTableView.reloadData()
   }
//    
}

