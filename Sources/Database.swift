import Logging
import Foundation
import SQLite

class Database {
    private let logger = Logger(label: "Database")
    private var db: Connection

    let tCourseInfo = Table("course_info")
    let uCode = Expression<String>("unit_code")
    let uName = Expression<String>("unit_name")
    let link = Expression<String>("link")
    let uDesc = Expression<String>("unit_desc")
    let credit = Expression<Double>("credit")
    let semester = Expression<String>("semester")
    let special = Expression<Bool>("special")

    let tPrereq = Table("course_prereq")
    let uPrereq = Expression<String>("prereq")

    init(conn:Connection) {
        db = conn
        createTables()
    }

    private func createTables() {
        let query1 = tCourseInfo.create { (t:TableBuilder) in 
            t.column(uCode, primaryKey: true)
            t.column(uName)
            t.column(link)
            t.column(uDesc)
            t.column(credit)
            t.column(semester)
            t.column(special)

        }
        if let _ = try? db.execute(query1) {
            logger.info("course_info table created")
        } else {
            logger.info("course_info table exists")
        } 

        let query2 = tPrereq.create { (t:TableBuilder) in 
            t.column(uCode, primaryKey: true)
            t.column(uPrereq, primaryKey: true)
        }
        if let _ = try? db.execute(query2) {
            logger.info("course_prereq table created")
        } else {
            logger.info("course_prereq table exists")
        } 
    }
}