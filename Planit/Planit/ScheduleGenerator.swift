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
        for task in task_list{
            print("\(task.id) start_date : \(formatter.string(from:task.start_date)) deadline : \(task.deadline) workload : \(task.workload)")
            //print(task)
        }
        
        let sorted_tasks = task_list.sorted(by: {$0.deadline < $1.deadline})
        var num_tasks_this_day:[String:Float] = [:]
        let today_string = formatter.string(from:today)


        for index in 0..<sorted_tasks.count{
            let due = formatter.date(from: sorted_tasks[index].deadline)!
            var left = Calendar.current.dateComponents([.day], from: today, to: due)
        
            //  print("\(left.day!+1) and \(sorted_tasks[index].workload)")
            var workload_per_day = Float(sorted_tasks[index].workload)/Float(left.day!+1)
            var start_date:Date = formatter.date(from:today_string)!
            var count = 7
            //print("\(workload_per_day)")
            
            if workload_per_day < 0.5 {
                let idle_time = (left.day!+1) - 2 * sorted_tasks[index].workload
                start_date = Calendar.current.date(byAdding: .day, value: idle_time, to: start_date)!
                left = Calendar.current.dateComponents([.day], from: start_date, to: due)
                workload_per_day = Float(sorted_tasks[index].workload)/Float(left.day!+1)
            }
            
            while count > 0{
                if left.day!+1 < 3 {
                    break
                }
                if var val  = num_tasks_this_day[formatter.string(from:start_date)] {
                    if val >= 5 {
                        start_date = Calendar.current.date(byAdding: .day, value: 1, to: start_date)!
                    }else {
                        val = val + workload_per_day
                        num_tasks_this_day.updateValue(val, forKey: formatter.string(from:start_date))
                    }
                }else{
                    num_tasks_this_day[formatter.string(from: start_date)] = 1
                }
                count-=1
            }
            
            //print("\(workload_per_day)")

            sorted_tasks[index].amount_of_a_day = workload_per_day
            sorted_tasks[index].start_date = start_date
            sorted_tasks[index].left_days = left.day!+1
        }

        print("========after======")
        for task in sorted_tasks{
            print("\(task.title) start_date : \(formatter.string(from:task.start_date)) deadline : \(task.deadline) workload per day: \(task.amount_of_a_day) " )
           // print(task)
        }

        return sorted_tasks
    }
}
