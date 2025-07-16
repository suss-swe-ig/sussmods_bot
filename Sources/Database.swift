import Logging
import SQLite


class DB {
    private let logger = Logger(label: "Database")
    private var db: Connection

    let tCourseInfo = Table("course_info")
    let uCode = Expression<String>("unit_code")
    let uName = Expression<String?>("unit_name")
    let link = Expression<String?>("link")
    let uDesc = Expression<String?>("unit_desc")
    let credit = Expression<Double?>("credit")
    let semester = Expression<String?>("semester")
    let special = Expression<Bool?>("special")

    let tPrereq = Table("course_prereq")
    let uPrereq = Expression<String>("prereq")

    init(at path:String) {
        db = try! Connection(path) 
        createTables()
    }

    func getConnection() -> Connection {
        return db
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
            t.foreignKey(uCode, references: tCourseInfo, uCode)
            t.foreignKey(uPrereq, references: tCourseInfo, uCode)
        }
        if let _ = try? db.execute(query2) {
            logger.info("course_prereq table created")
        } else {
            logger.info("course_prereq table exists")
        } 
    }

    func getTelegramGroups() -> (Table, Expression<String>, Expression<String?>, Expression<String?>) {
        return (tCourseInfo, uCode, uName, link)
    }
}