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
    var duration:Int
    var left_days = 0
    var start_date:Date
    var amount_of_a_day:Float = 0.0
    
    init(id: Int, title: String, deadline: String, duration:Int){

        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        self.id = id
        self.title = title
        self.deadline = deadline
        self.duration = duration
        self.start_date = formatter.date(from:"10-01-2020")!
    }
}
