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
    var left_days:Int
    var start_date:Date
    var amount_of_a_day:Float
    var note:String
    let formatter = DateFormatter()
    
    init(id: Int, title: String, deadline: String, workload:Int, start_date:Date, note:String){

        formatter.dateFormat = "MM/dd/yy HH:mm"
        self.id = id
        self.title = title
        self.deadline = deadline
        self.workload = workload
        self.start_date = start_date
        self.note = note
        self.left_days = 0
        self.amount_of_a_day = 0.0
    }
    
    func getLeftDays()-> Int{
        self.left_days = Calendar.current.dateComponents([.day], from: Date(), to: formatter.date(from: deadline)!).day!
        return left_days
    }
    
    func isDeadlineComing(deadline:String) -> Bool{
        if (self.getLeftDays() <= 2) {return true}
        return false
    }
    
    
}
