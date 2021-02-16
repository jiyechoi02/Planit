//
//  UserSettingController.swift
//  Planit
//
//  Created by Jiye Choi on 11/17/20.
//

import Foundation
import UIKit

class UserSettingController: UIViewController{
    
    @IBOutlet weak var maxWorkPerDay: UISlider!
    @IBOutlet weak var minWorkPerDay: UISlider!
    @IBOutlet weak var maxLateStart: UISlider!
    let db:DBManager = DBManager()
    
    @IBAction func SaveAction(_ sender: Any) {
        
        let max_hrs = maxWorkPerDay.value
        let min_hrs = minWorkPerDay.value
        let max_late = maxLateStart.value
        print(" \(max_hrs) \(min_hrs) \(max_late)" )
        
        var alert:UIAlertController
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
        })
        if (max_hrs < min_hrs) {
            alert = UIAlertController(title: "Warning", message: "The max value is smaller than the min value. Try Again.", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            if(db.updateUserDate(name: "Jiye", max_hrs: max_hrs, min_hrs: min_hrs, late_days: max_late) == 1){
                alert = UIAlertController(title: "Success!", message: "Just updated your setting!", preferredStyle: .alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                maxWorkPerDay.setValue(0.0, animated: true)
                minWorkPerDay.setValue(0.0, animated: true)
                maxLateStart.setValue(0.0, animated: true)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass sorted list and events to the calendarview
        
        if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            vc?.updateUserSetting()
            vc?.update()
        }
    }
}
