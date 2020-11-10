//
//  Task.swift
//  Planit
//
//  Created by Jiye Choi on 11/1/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import Foundation

class Task
{
    var id:Int
    var title:String
    var deadline:String
    var workload:Int
    var left_days = 0
    var start_date:Date
    var amount_of_a_day:Float = 0.0
    
    init(id: Int, title: String, deadline: String, workload:Int){

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY HH:mm"
        self.id = id
        self.title = title
        self.deadline = deadline
        self.workload = workload
        self.start_date = Date()
    }
}
