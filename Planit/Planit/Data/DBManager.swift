//
//  DBManager.swift
//  Planit
//
//  Created by Jiye Choi on 11/1/20.

import Foundation

class DBManager
{
    var formatter = DateFormatter()
    var dbPath: String = ""
    var db: OpaquePointer?  // SQLite connection
    
    init()
    {
        dbPath = self.getPath()
        db = connectDB()
        self.createTable(dbPath: dbPath)
        self.createUserTable(dbPath: dbPath)
    }
    
    func connectDB() -> OpaquePointer? {
        
        var db:OpaquePointer? = nil
//        let dbPath = "./db.sqlite"
        if sqlite3_open(dbPath, &db) != SQLITE_OK
        {
            print("ERROR : connecting Database")
            return nil
        } else
        {
            print("SUCCESS : connecting Database")
            return db
        }
        
    }
    
    func getPath() -> String {
        let fileManager = FileManager()
        let pathUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = pathUrl.appendingPathComponent("planit.sqlite").path

        if fileManager.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "planit", ofType: "sqlite")
            // copyItem takse both urls
            try! fileManager.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        return dbPath
    }

    func createTable(dbPath : String) {
    
        var stmt: OpaquePointer? = nil // compiled sql
        
//        let dbPath = "/Users/jiyechoi/Desktop/db.sqlite"
        let sql = "CREATE TABLE IF NOT EXISTS task (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, deadline TEXT, workload INTEGER, startDate TEXT)"
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("SUCCESS : creating table")
            }
        } else {
            print("ERROR : preparing statement")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
        }
        
        sqlite3_finalize(stmt)
    }
    
    func insertData(title:String, deadline:String, workload:Int, startDate:String, note:String = "") -> Int
    {
        let sql = "INSERT INTO task (title, deadline, workload, startDate) VALUES (?,?,?,?)"
        var stmt: OpaquePointer? = nil // compiled sql
        var flag: Int = 0
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
            sqlite3_bind_text(stmt, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (deadline as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 3, Int32(workload))
            sqlite3_bind_text(stmt, 4, (startDate as NSString).utf8String, -1, nil)
            //sqlite3_bind_text(stmt, 5, (note as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) == SQLITE_DONE
            {
                print("SUCCESS : inserting data")
                flag = 1

            } else
            {
                print("ERROR : inserting data")
                flag = -1
            }
        } else
        {
            print("ERROR : preparing INSERT statsment")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
            flag = -1

        }
        sqlite3_finalize(stmt)
    
        return flag
    }
    func updateDate(title:String, deadline:String, workload:Int, startDate:String, note:String = "")->Int{
        let sql = "UPDATE task SET title=?, deadline=?, workload=?, startDate=?"
        var stmt: OpaquePointer? = nil
        var flag: Int = 0
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
            sqlite3_bind_text(stmt, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (deadline as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 3, Int32(workload))
            sqlite3_bind_text(stmt, 4, (startDate as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) == SQLITE_DONE
            {
                print("SUCCESS : Update data")
                flag = 1

            } else
            {
                print("ERROR : Update data")
                flag = -1
            }
        } else
        {
            print("ERROR : preparing UPDATE statsment")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
            flag = -1

        }
        sqlite3_finalize(stmt)
    
        return flag
    }
    func readData() -> [Task] {
        formatter.dateFormat = "MM/dd/yy HH:mm"
        
        let sql = "SELECT * FROM task"
        var stmt: OpaquePointer? = nil
        var task_list : [Task] = []
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
            while sqlite3_step(stmt) == SQLITE_ROW
            {
                let id = sqlite3_column_int(stmt, 0)
                let title =  String(describing: String(cString: sqlite3_column_text(stmt, 1)))
                let deadline = String(describing: String(cString: sqlite3_column_text(stmt, 2)))
                let workload = sqlite3_column_int(stmt, 3)
                let startDate = String(describing: String(cString: sqlite3_column_text(stmt, 4)))
              //  let note = String(describing: String(cString: sqlite3_column_text(stmt, 5)))
                task_list.append(Task(id: Int(id), title: title, deadline: deadline, workload: Int(workload), start_date: formatter.date(from: startDate)!, note: ""))
                print("\(id) : \(title) : \(deadline) : \(workload)")
            }
        } else
        {
            print("ERROR : reading data from the table")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
        }
        sqlite3_finalize(stmt)
        return task_list
    }
    
    func deleteById(id:Int)
    {
        let sql = "DELETE FROM task WHERE id = ?"
        var stmt : OpaquePointer? = nil
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
            sqlite3_bind_int(stmt, 1, Int32(id))
            if sqlite3_step(stmt) == SQLITE_DONE
            {
                print("SUCCESS : deleting data")
            } else
            {
                print("ERROR : deleting data")
            }
        } else {
            print("ERROR : preparing DELETE stmt")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
        }
        sqlite3_finalize(stmt)
        
    }
    
    
    func createUserTable(dbPath : String) {
    
        var stmt: OpaquePointer? = nil // compiled sql
        
//        let dbPath = "/Users/jiyechoi/Desktop/db.sqlite"
        let sql = "CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, min_hrs FLOAT, max_hrs FLOAT, late_days FLOAT)"
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("SUCCESS : creating table")
            }
        } else {
            print("ERROR : preparing statement")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
        }
        
        sqlite3_finalize(stmt)
    }
    
    func insertUserData(name:String, min_hrs:Float, max_hrs:Float, max_late_days:Float) -> Int
    {
        let sql = "INSERT INTO user (name, min_hrs, max_hrs, late_days) VALUES (?,?,?,?)"
        var stmt: OpaquePointer? = nil // compiled sql
        var flag: Int = 0
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
            sqlite3_bind_text(stmt, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_double(stmt, 2, Double((min_hrs)))
            sqlite3_bind_double(stmt, 3, Double((max_hrs)))
            sqlite3_bind_double(stmt, 4, Double((max_late_days)))
            
            if sqlite3_step(stmt) == SQLITE_DONE
            {
                print("SUCCESS : inserting data")
                flag = 1

            } else
            {
                print("ERROR : inserting data")
                flag = -1
            }
        } else
        {
            print("ERROR : preparing INSERT statsment")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
            flag = -1

        }
        sqlite3_finalize(stmt)
    
        return flag
    }
    
    func readUserData(name: String) -> [String:Float]{
        
        let sql = "SELECT * FROM user WHERE name=?"
        var stmt: OpaquePointer? = nil
        var map:[String:Float] = [:]
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
            sqlite3_bind_text(stmt, 1, (name as NSString).utf8String, -1, nil)
            
            while sqlite3_step(stmt) == SQLITE_ROW
            {
                let id = sqlite3_column_int(stmt, 0)
                let username =  String(describing: String(cString: sqlite3_column_text(stmt, 1)))
                let min_hrs = sqlite3_column_int(stmt, 2)
                let max_hrs = sqlite3_column_int(stmt, 3)
                let late_days = sqlite3_column_int(stmt, 4)
              //  let note = String(describing: String(cString: sqlite3_column_text(stmt, 5)))
                map["min_hrs"] = Float(min_hrs)
                map["max_hrs"] = Float(max_hrs)
                map["late_days"] = Float(late_days)
                
                print("\(id) : \(min_hrs) : \(max_hrs) : \(late_days)")
            }
        } else
        {
            print("ERROR : reading data from the table")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
        }
        sqlite3_finalize(stmt)
        return map
    }
    
    func deleteTable()
    {
        let sql = "DROP TABLE user"
        var stmt : OpaquePointer? = nil
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
            if sqlite3_step(stmt) == SQLITE_DONE
            {
                print("SUCCESS : deleting table")
            } else
            {
                print("ERROR : deleting table")
            }
        } else {
            print("ERROR : preparing DELETE stmt")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
        }
        sqlite3_finalize(stmt)
        
    }
    
    func updateUserDate(name: String, max_hrs:Float, min_hrs:Float, late_days:Float)->Int{
        let sql = "UPDATE user SET name=?, min_hrs=?, max_hrs=?, late_days=?"
        var stmt: OpaquePointer? = nil
        var flag: Int = 0
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
            sqlite3_bind_text(stmt, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 2, Int32(min_hrs))
            sqlite3_bind_int(stmt, 3, Int32(max_hrs))
            sqlite3_bind_int(stmt, 4, Int32(late_days))
            
            if sqlite3_step(stmt) == SQLITE_DONE
            {
                print("SUCCESS : Update data")
                flag = 1

            } else
            {
                print("ERROR : Update data")
                flag = -1
            }
        } else
        {
            print("ERROR : preparing UPDATE statsment")
            NSLog("Database Error Message : %s", sqlite3_errmsg(db));
            flag = -1

        }
        sqlite3_finalize(stmt)
    
        return flag
    }
}
