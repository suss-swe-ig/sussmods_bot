//
//  TgGroups.swift
//  sussmods_bot
//
//  Created by Donaldson Tan on 5/7/25.
//

import SQLite
import Logging

class TgGroups {
    let logger = Logger(label: "TgGroups")
    let table = Table("telegram_groups")
    let uCode = Expression<String>("unit_code")
    let uName = Expression<String>("unit_name")
    let link = Expression<String>("link")
    var db: Connection
    
    init(conn:Connection) {
        db = conn
        createTable()
    }
       
    private func createTable() {
        do {
            try db.execute(table.create { t in
                t.column(uCode, primaryKey: true)
                t.column(uName)
                t.column(link)
            })
            logger.info("telegram_groups table created")
        } catch {
            // if the table already exists, this would result in error
            // don't do anything
            logger.info("telegram_groups table found in database")
        }
    }
    
    subscript(code:String) -> (String,String)? {
        get {
            let query = table.select(uCode, uName, link).filter(uCode == code.uppercased())
            do {
                for tg in try db.prepare(query) {
                    return (tg[uName], tg[link])
                }
            } catch {}
            // if query yields no result
            return nil
        }
        set(newValue) {
            if let (uname, ulink) = newValue {
                let query = table.upsert(uCode <- code.uppercased(), uName <- uname, link <- ulink, onConflictOf: uCode)
                do {
                    try db.run(query)
                    logger.info("added \(code.uppercased()): \(uname), link: \(ulink)")
                } catch {
                    logger.error("failed to update \(code.uppercased())")
                }
            } else {
                let query = table.filter(uCode == code.uppercased()).delete()
                do {
                    try db.run(query)
                    logger.info("deleted \(code.uppercased())")
                } catch {
                    logger.error("failed to delete \(code.uppercased())")
                }
            }
        
        }
    }
}
