import Logging
import Foundation
import SQLite

class Database {
    let logger = Logger(label: "Database")
    let tTgGroups = Table("telegram_groups")
    let uCode = Expression<String>("unit_code")
    let uLink = Expression<String>("link")
    let tCourseInfo = Table("course_info")
    let uName = Expression<String>("unit_name")
    var db: Connection

    init(conn:Connection) {
        db = conn
        createTables()
    }

    private func createTables() {
        let query1 = tCourseInfo.create { (t:TableBuilder) in 
            t.column(uCode, primaryKey: true)
            t.column(uName)
        }
        if let _ = try? db.execute(query1) {
            logger.info("course_info table created")
        } else {
            logger.info("course_info table exists")
        }

        let query2 = tTgGroups.create { (t:TableBuilder) in 
            t.column(uCode, primaryKey: true)
            t.column(uLink)
        }
        if  let _ = try? db.execute(query2) {
            logger.info("telegram_groups table created")
        } else {
            logger.info("telegram_groups table exists")
        }
    }
}