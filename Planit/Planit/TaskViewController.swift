//
//  TaskViewController.swift
//  Planit
//
//  Created by Jiye Choi on 10/14/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

// This page is for Adding task page
import UIKit

class TaskViewController: UIViewController {
    // UIs
    @IBOutlet weak var workloadSlider: UISlider!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textfield_title: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let dateFormatter: DateFormatter = DateFormatter() // date formatter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        let db:DBManager = DBManager()// connect to db
        var alert:UIAlertController
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
        })
        if textfield_title.text!.isEmpty{      // if the titile txt field is empty, warn the user
            alert = UIAlertController(title: "Warning", message: "It must not be empty", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{                                 // else, send user input to the db
            let selectedDate: String = dateFormatter.string(from: datePicker.date)
            let inputTitle = textfield_title.text!
            let workload = Int(workloadSlider.value)
            if db.insertData(title: inputTitle, deadline: selectedDate, workload: workload) == 1 {
                alert = UIAlertController(title: "Success!", message: "Just add a new task", preferredStyle: .alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                textfield_title.text = ""
                datePicker.setDate(Date(), animated: true)
                workloadSlider.setValue(0.0, animated: true)
            }else {
                print("ERROR")
            }
        }
    }
    
    @IBAction func clearEvent(_ sender: Any) {
        textfield_title.text = ""
        datePicker.setDate(Date(), animated: true)
        workloadSlider.setValue(0.0, animated: true)
    }
    
    
    @IBAction func cancelEvent(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    
}
