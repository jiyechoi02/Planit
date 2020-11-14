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
    // UIs
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var todayTaskTableView: UITableView!
    @IBOutlet weak var taskTable: UITableView! // task table view

    
    let taskCellId = "cellID" // identifier for each cell
    var task_list:[Task] = [] // to store data from the database
    
    var db:DBManager = DBManager() // connect database
    
    var dataArr:[String]? = []
    var text_selectedCell:String? = ""
    var sorted_task_list:[Task]=[]
    let sg:ScheduleGenerator = ScheduleGenerator()
    
    var today_todo_list:[Task] = []
    let todayCellId = "todayCell"
    
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
        today_todo_list = getTodaysTask(task_list: sorted_task_list)
        print("todayys list count : \(today_todo_list.count)")

    }
    func getTodaysTask(task_list:[Task])-> [Task]{
        var today_task_list:[Task] = []
        for task in task_list{
            formatter.dateFormat = "MM/dd/YY HH:mm"
           // String(str.split(separator: " ")[0])
            let deadline = String(task.deadline.split(separator: " ")[0])
            let todayStr = String(formatter.string(from: today).split(separator: " ")[0])
            if(deadline == todayStr){
                today_task_list.append(task)
            }
        }
        return today_task_list
    }
    // to identify the segue named "firstLink" (main - calendar) and follow that segue to open another view.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        performSegue(withIdentifier: "firstLink", sender: self)
    }
    
    // initialize refresh controller
    func prepareRefresh() {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(updateTable(refreshController:)), for: .valueChanged)
        refreshController.attributedTitle = NSAttributedString(string: "refresh")
        if #available(iOS 10.0, *){
            taskTable.refreshControl = refreshController
        }else {
            taskTable.addSubview(refreshController)
        }
    }
    
    // when user refreshes the table, it read the DB and reload for update
    @objc func updateTable(refreshController : UIRefreshControl){
        refreshController.endRefreshing()
        task_list = db.readData()
        sorted_task_list = sg.generate(task_list: task_list)
        today_todo_list = getTodaysTask(task_list: sorted_task_list)
        taskTable.reloadData()
        todayTaskTableView.reloadData()
    }
    
    @IBAction func deleteDataEvent(_ sender: Any) {
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

    
    @IBAction func SettingEvent(_ sender: Any) {
    }
    
    @IBAction func AddEvent(_ sender: Any) {
        performSegue(withIdentifier: "addTaskSegue", sender: self)
    }
    
    @IBAction func EditEvent(_ sender: Any) {
        
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
        if segue.destination is CalendarViewController {
            let vc = segue.destination as? CalendarViewController
            vc?.task_list = sorted_task_list
        }
    }
}

