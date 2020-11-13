# CS491Planit

# Planit App to-do lists
- Algorithm 
1. Complete the Algorithm

- Main Page 
2. How to reload after update table view? 
—> pull down working (refresh)! but reload whole data every time,  fix to add only new data to the list, auto-refresh
3. Get data & generate start date --> After finishing the Algorithm

- Calendar Page 
<del>4. How to send them to the calendar --> need to implement our own calendar?</del>
5. Get data from the calendar and display today’s todo
<del>6. When we select date, show the todo list below</del>
7. not sure how to display 'bar' on events 
8. need to figure out how to display task from start date to end date 
9. still working on the calendar UI ofc!


- Task Page
7. add buttons (cancel, clear) 

---------------------------------------------------------------------------
# What I have done so far
1. Get connected app and database
2. Load Data from db to the table view Created ‘task class’
3. Add data / warning for empty
4. Date Picker data transfer  -> working now!  / date and time to string
5. LOGO 
6. Today's task loaded 


# BUG !
Thread 1: signal SIGTERM


# Algorithm

Input : tasks with deadline, workload
Variables : min_workload_per_day_for_each_task, max_total_workload_per_day

1. Calculate left days from current date to each deadline
2. Divide its workload by left days = workload_per_day until the deadline
3. If workload_per_day is less than a minimum amount of work per day for each work (aka min_workload_per_day)
    1. No need to hurry!
    2. increment start date by 1 (e.g. current date ++) until getting min_workload_per_day)
    3. Set the task start date
4. Or if on the start date, there are already max_total_workload_per_day,
    1. Too much work for a day!
    2. Increment start date by 1 until we find a date which has less than max_total_workload_per_day
    3. Set the task start date

# What to improve
1. If the user has days that users does not want to work tasks, how will it affect to the generated plan?
2. From #4 above, If  the user already has so much work to do, so we cannot find a day having less than max_total_workload_per_day?
3. What is the reasonable min_workload_per_day_for_each_task & max_total_workload_per_day? (Planning to give users options)
4. More feedback needed

# Feedback from class
Planit - Set up database, task table, schedule algorithm. Can add
tasks. Set deadline and workload. Can delete tasks. Algorithm uses minimum and maximum
workload per day. Work back from due date to find start date. Need to allow users to block out
dates. How to handle overloads? Need to give users options. May want to give users options
to select how early or late they like to work toward a deadline, and also to warn users when a
new task needs more than the maximum work that can be allocated before the deadline.


# JTAppleCalendar
------------------------------------------------------
To install JTAppleCalendar 
change the podfile with 


target 'Planit' do
  use_frameworks!

  pod 'JTAppleCalendar', '~> 7.1'

end

then command "pod install"
---------------------------------------




