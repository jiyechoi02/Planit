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
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var taskTable: UITableView! // task table view
    let cell_identifier = "cellID" // identifier for each cell
    var task_list:[Task] = [] // to store data from the database
    
    var db:DBManager = DBManager() // connect database
    
    var dataArr:[String]? = []
    var text_selectedCell:String? = ""
    var selectedTask:Task? = nil
    // setup
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.delegate = self
        taskTable.dataSource = self
        taskTable.register(UITableViewCell.self, forCellReuseIdentifier: cell_identifier)
        self.task_list = db.readData() // read data from the DB and store them in the list
        prepareRefresh() // For refresh the table view

    }
    // to identify the segue named "firstLink" (main - calendar) and follow that segue to open another view.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        performSegue(withIdentifier: "firstLink", sender: self)
    }
    
    @IBAction func deleteDataEvent(_ sender: Any) {
        if text_selectedCell!.isEmpty || selectedTask == nil{
            print("it's empty")
        }else{
            db.deleteById(id: selectedTask!.id)
            task_list = db.readData()
            taskTable.reloadData()
        }
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
        taskTable.reloadData()
    }
    
    /*----------Handling TableView ---------*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // To define how many rows are needed
        return task_list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuns whenever the table view needs to put data in its rows
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cell_identifier)!
        //let id = task_list[indexPath.row].id
        let title = task_list[indexPath.row].title
        let deadline = task_list[indexPath.row].deadline
        let duration = task_list[indexPath.row].duration
        
        let string = String(indexPath.row) + " " + title + " " + deadline + " " + String(duration)
        cell.textLabel?.text =  string
        
        return cell
    }
    //for seleced cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = self.taskTable.cellForRow(at: indexPath)
        text_selectedCell = selectedCell?.textLabel?.text
        selectedTask = task_list[indexPath.row]
    }
    /*------------------------------------*/
}

