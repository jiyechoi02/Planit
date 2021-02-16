//
//  EditTaskViewController.swift
//  Planit
//
//  Created by Jiye Choi on 11/17/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import Foundation
import UIKit

class EditTaskViewController : UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workPicker: UISlider!
    @IBOutlet weak var noteField: UITextField!
    
    var formatter : DateFormatter = DateFormatter()
    
    var task: Task?
    var task_list:[Task] = []
    
    override func viewDidLoad() {
        if #available(iOS 13.4, *){
            datePicker.preferredDatePickerStyle = .wheels
        }
        formatter.dateFormat = "MM/dd/yy HH:mm"
        titleLabel.text = task!.title
        datePicker.setDate(formatter.date(from : task!.deadline)!, animated: true)
        workPicker.setValue(Float(task!.workload), animated: true)
        
    }
//    @IBAction func updateTable(_ sender: Any) {
//        let db:DBManager = DBManager()
//        var alert:UIAlertController
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
//        })
//        if titleField.text!.isEmpty{      // if the titile txt field is empty, warn the user
//            alert = UIAlertController(title: "Warning", message: "It must not be empty", preferredStyle: .alert)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//        }else{                                 // else, send user input to the db
//            let selectedDate: String = formatter.string(from: datePicker.date)
//            let inputTitle = titleField.text!
//            let workload = Int(workPicker.value)
//            let startDate = formatter.string(from: Date())
//            let note = noteField.text ?? ""
//
//            if(formatter.date(from: selectedDate)! < Date()){
//                alert = UIAlertController(title: "Warning", message: "Invalid Deadline", preferredStyle: .alert)
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//                datePicker.setDate(Date(), animated: true)
//            }else{
//                if db.updateDate(title: inputTitle, deadline: selectedDate, workload: workload, startDate: startDate) == 1 {
//                    task_list = db.readData()
//                    alert = UIAlertController(title: "Success!", message: "Just add a new task", preferredStyle: .alert)
//                    alert.addAction(okAction)
//                    self.present(alert, animated: true, completion: nil)
//                    titleField.text = ""
//                    datePicker.setDate(Date(), animated: true)
//                    workPicker.setValue(0.0, animated: true)
//                    noteField.text = ""
//                }else {
//                    print("ERROR")
//                }
//            }
//        }
//
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Pass sorted list and events to the calendarview
//        if segue.destination is ViewController {
//            let vc = segue.destination as? ViewController
//            vc?.update()
//        }
//    }
    
}
