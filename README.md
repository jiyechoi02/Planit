# Planit

# Planit App to-do lists

Our goal is to create a simple to use algorithmic based planner to help students complete their goals by generating optimal orderings and time allotments for their tasks based on deadlines and workload.

- Stack 
  - DBManager.swift 
    -    to create a database with tables to hold user information and the ability to call database anywhere within the app
  - ScheduleGenerator.swift
    -  Class that gives us our generate function that given an array of user tasks will return sorted array of the tasks ordered by workload and deadline
  - JTAppleCalendar 
    -    Swift Calendar Library to customize the calendar feature 

# Features 
    1. Main page 
        - Today’s Todo list
        - Total Task list
        - This sign for task whose the deadline is coming 
        - title, deadline and also workload hour(s) for today and total 
        - Setting button
        - Add button 
        
     2. Task Page 
        -   Add a new task 
        - Cancel  button
        - Clear  button 
        -  Save button
     3. 
        - Marking today, selected dates
        - Stars - Tasks on the dates
        - Users can see each date’s task by clicking the date 
        - task list shows the deadline coming sign,title, and work hour(s) on that date
     4. 
        - Max work hours per day (default: 5) :
        - How many max hours (or just think about workload) the user wishes to do tasks.
        - Min work hours per day (default: 0.5) :
        - How many min hours (or just think about workload) the user wish to do tasks 
        - The latest Start date (default: 3) :
        - This is for the worst cast that a task cannot find a proper start date since every day until the deadline are full with the max   work hours.
        
    5. 
        - View each Task by tapping  a task

        
# Generating Schedule algorithm 
1. Input : 

        - Tasks with
        - deadline  
        - Workload : User chooses the estimated time needed to complete the task Range [1,10] 
        - E.g. 311 homework = 10 h

2. Variables : 

       - Min_workload_per_day_for_each_task  :
       - Minimum workload per day for each task 
       - Max_total_workload_per_day 
       - Maximum total workload per day 

3. Algorim :

        1) Sort tasks by their deadlines
        2) Calculate left days from current date to each deadline 
        3) Divide its workload by left days = workload_per_day until the deadline 
        4) If workload_per_day is less than min_workload_per_day
            - No need to hurry!
            - increment start date by 1 (e.g. current date ++) until getting min_workload_per_day
            - Set the task start date 
        5) Or if on the start date, there are already max_total_workload_per_day, 
            - Too much work for a day!
            - Decrement or Increment start date by 1 until we find a date which has less than max_total_workload_per_day
            - Set the task start date 



# Feedback from class
Planit - Set up database, task table, schedule algorithm. Can add
tasks. Set deadline and workload. Can delete tasks. Algorithm uses minimum and maximum
workload per day. Work back from due date to find start date. Need to allow users to block out
dates. How to handle overloads? Need to give users options. May want to give users options
to select how early or late they like to work toward a deadline, and also to warn users when a
new task needs more than the maximum work that can be allocated before the deadline.


# How to install and configure JTAppleCalendar in the program
To install JTAppleCalendar 

change the podfile with 


target 'Planit' do
  use_frameworks!

  pod 'JTAppleCalendar', '~> 7.1'

end

then command "pod install"





