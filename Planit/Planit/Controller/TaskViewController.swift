//
//  TaskViewController.swift
//  Planit
//
//  Created by Jiye Choi on 10/14/20.
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
    @IBOutlet weak var textfield_note: UITextField!
    
    let dateFormatter: DateFormatter = DateFormatter() // date formatter
    var task_list: [Task] = []
    let sg:ScheduleGenerator = ScheduleGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if #available(iOS 13.4, *){
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        let db:DBManager = DBManager()// connect to db
        var alert:UIAlertController
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
        })
        if textfield_title.text!.isEmpty{      // if the titile txt field is empty, warn the user
            alert = UIAlertController(title: "Warning", message: "The title must not be empty", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{                                 // else, send user input to the db
            let selectedDate: String = dateFormatter.string(from: datePicker.date)
            let inputTitle = textfield_title.text!
            let workload = Int(workloadSlider.value)
            let startDate = dateFormatter.string(from: Date())
            let note = textfield_note.text ?? ""
            
            if(dateFormatter.date(from: selectedDate)! < Date()){
                alert = UIAlertController(title: "Warning", message: "Invalid Deadline", preferredStyle: .alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                print(dateFormatter.date(from :selectedDate)!)
                print(Date())
                datePicker.setDate(Date(), animated: true)
            }else{
                if db.insertData(title: inputTitle, deadline: selectedDate, workload: workload, startDate: startDate, note: note) == 1 {
                    task_list = db.readData()
                    alert = UIAlertController(title: "Success!", message: "Just added a new task", preferredStyle: .alert)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    textfield_title.text = ""
                    datePicker.setDate(Date(), animated: true)
                    workloadSlider.setValue(0.0, animated: true)
                    textfield_note.text = ""
                }else {
                    print("ERROR")
                }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass sorted list and events to the calendarview
        if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            vc?.update()
        }
    }
    
}
