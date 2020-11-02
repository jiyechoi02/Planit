//
//  ScheduleGenerator.swift
//  Planit
//
//  Created by Jiye Choi on 11/1/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import Foundation
class ScheduleGenerator {
    
    let formatter = DateFormatter()
    let today: Date = Date()
    
    init(){
        formatter.dateFormat = "MM/dd/yy HH:mm"
    }
    
    func generate(task_list:[Task] ) -> [Task] {
        let sorted_tasks = task_list.sorted(by: {$0.deadline < $1.deadline})
        for index in 0..<sorted_tasks.count{
         //   let deadline = formatter.date(from: sorted_tasks[index].deadline)

//            let left = Calendar.current.dateComponents([.day], from: today, to: deadline!)
//            sorted_tasks[index].left_days = left.day!
//            let amount_of_a_day = Float(sorted_tasks[index].workload)/Float(left.day!)
//            sorted_tasks[index].amount_of_a_day = amount_of_a_day
//            if amount_of_a_day < 0.5{
//                let idle_time = left.day! - 2 * sorted_tasks[index].workload
//               sorted_tasks[index].start_date = Calendar.current.date(byAdding: .day, value: idle_time, to: today)!
//            }
        }

        return sorted_tasks
    }
}
