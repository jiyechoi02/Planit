//
//  TaskViewController.swift
//  Planit
//
//  Created by Jiye Choi on 10/14/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    let dateFormatter: DateFormatter = DateFormatter()
    
    @IBOutlet weak var workloadSlider: UISlider!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textfield_title: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
    }

    @IBAction func add_button_event(_ sender: Any) {
        let db:DBManager = DBManager()
        if textfield_title.text!.isEmpty{
            let alert = UIAlertController(title: "Warning", message: "It must not be empty", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let selectedDate: String = dateFormatter.string(from: datePicker.date)
            let inputTitle = textfield_title.text!
            let workload = Int(workloadSlider.value)
            if db.insertData(title: inputTitle, deadline: selectedDate, workload: workload) == 1 {
                textfield_title.text = ""
            }else {
                print("ERROR")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
