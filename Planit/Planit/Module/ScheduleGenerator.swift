//
//  ScheduleGenerator.swift
//  Planit
//
//  Created by Jiye Choi on 11/1/20.

import Foundation
class ScheduleGenerator {
    
    let formatter = DateFormatter()
    let today: Date = Date()
    
    init(){
        formatter.dateFormat = "MM/dd/yy HH:mm"
    }
    
    func generate(task_list:[Task], min_work_per_day: Float = 0.5, max_work_per_day: Float = 5, max_late_days:Float = 3) -> [Task] {
        for task in task_list{
            print("\(task.title) start_date : \(formatter.string(from:task.start_date)) deadline : \(task.deadline) total workhour : \(task.workload)")
            //print(task)
        }
     //   print("User Setting : \(min_work_per_day) \(max_work_per_day) \(max_late_days)")
        
        let sorted_tasks = task_list.sorted(by: {$0.deadline < $1.deadline})
        var num_tasks_this_day:[String:Float] = [:]
        let today_string = formatter.string(from:today)
        //var left_days = 0
        
        for task in sorted_tasks{
            let due = formatter.date(from: task.deadline)!
            var left = Calendar.current.dateComponents([.day], from: task.start_date, to: due)
            
//var blockedDates : [String] = ["11/18/20 12:111", "11/19/20 12:14"]
//            print("\(left.day!+2) and \(sorted_tasks[index].workload)")
            var workload_per_day = Float(task.workload)/Float(left.day!+1)


            var start_date:Date =  task.start_date
           // var count = 7
           // print("This  \(sorted_tasks[index].title) : \(workload_per_day)")
            
            while workload_per_day < min_work_per_day {
                
//                print("start daye : \(start_date) left days : \(left.day!+1) and workper : \(workload_per_day)")
              //  print("too little \(task.title) : \(workload_per_day)")
                if(left.day!+1 <= Int(max_late_days)){
                    left = Calendar.current.dateComponents([.day], from: start_date, to: due)
                    workload_per_day = Float(task.workload)/Float(left.day!+1)
                    
                  //  print("start daye : \(start_date) left days : \(left.day!+1) and workhours per day : \(workload_per_day)")
                    break
                }
                start_date = Calendar.current.date(byAdding: .day, value: 1, to: start_date)!
                left = Calendar.current.dateComponents([.day], from: start_date, to: due)
                workload_per_day = Float(task.workload)/Float(left.day!+1)
            }
            
//            left = Calendar.current.dateComponents([.day], from: start_date, to: due)
//            workload_per_day = Float(sorted_tasks[index].workload)/Float(left.day!+2)
            
            if var val  = num_tasks_this_day[formatter.string(from:start_date)] {
                if val >= max_work_per_day {
                  //  print("\(formatter.string(from:start_date)) has \(val)" )
                    while left.day!+1 >= Int(max_late_days){
                        left = Calendar.current.dateComponents([.day], from: start_date, to: due)
//                        if left.day!+1 < 3{
//                            break
//                        }
                     //   print("It is too much for you.. \(task.title) : \(workload_per_day) \(left.day!+1)")
                        start_date = Calendar.current.date(byAdding: .day, value: 1, to: start_date)!
//                        count-=1
                    }

                }
                val = val + workload_per_day
                num_tasks_this_day.updateValue(val, forKey: formatter.string(from:start_date))
            }else{
                num_tasks_this_day[formatter.string(from: start_date)] = workload_per_day
            }
            
            task.start_date = start_date
            task.left_days = left.day!+1
            left = Calendar.current.dateComponents([.day], from: start_date, to: due)
            workload_per_day = Float(task.workload)/Float(left.day!+1)
            task.amount_of_a_day = workload_per_day
        }

        print("========after======")
        for task in sorted_tasks{
            print("\(task.title) start_date : \(formatter.string(from:task.start_date)) deadline : \(task.deadline) workhours per day: \(task.amount_of_a_day) total workhours : \(task.workload) left_days : \(task.left_days)"  )
           // print(task)
        }

        return sorted_tasks
    }
}
