//
//  TgGroups.swift
//  sussmods_bot
//
//  Created by Donaldson Tan on 5/7/25.
//

import SQLite
import Logging

struct TgGroupsIterator: Sequence, IteratorProtocol {
    typealias Element = String
    let iterator: AnyIterator<Row>?
    let col: Expression<String>
    private var n: Int? 

    var count: Int {
        get { 
            if let c = n {
                return c 
            }
            return 0
         }
    }

    init(rows: AnySequence<Row>?, column:Expression<String>, count:Int?) {
        iterator = rows?.makeIterator()
        col = column
        n = count
    }


    func makeIterator() -> TgGroupsIterator {
        return self
    }

    mutating func next() -> String? {
        return iterator?.next()?[col]
    }

    /// This method converts the iterator to a list of unit codes
    func toList() -> [String] {
        var result: [String] = []
        for code in self {
            result.append(code)
        }
        return result
    }
}


/// TgGroups is a key-value store for Telegram Groups. 
/// The key is the unit code while the value is a pair of 
/// String representing the unit name and its telegram link.
class TgGroups: Sequence {
    let logger = Logger(label: "TgGroups")
    var db: DB
    var conn: Connection

    var count:Int {
        get {
            let (table, _, _, _) = db.getTelegramGroups()
            if let n = try? conn.scalar(table.count) {
                return n
            }
            return 0
        }
    }
    
    /// Constructor
    /// - Parameter conn: An sqlite3 database connection 
    init(_ connectTo: DB) {
        db = connectTo
        conn = connectTo.getConnection()
    }
   
    subscript(code:String) -> (String,String)? {
        get {
            let (table, uCode, uName, link) = db.getTelegramGroups()
            let query = table.select(uName, link).filter(uCode == code.uppercased())
            do {
                for row in try conn.prepare(query) {
                    if let uname = row[uName], let ulink = row[link] {
                        return (uname, ulink)
                    } else {
                        break
                    }
                }
            } catch {}
            // if query yields no result
            return nil
        }
        set(newValue) {
            let (table, uCode, uName, link) = db.getTelegramGroups()
            if let (uname, ulink) = newValue {
                let query = table.upsert(uCode <- code.uppercased(), uName <- uname, link <- ulink, onConflictOf: uCode)
                do {
                    try conn.run(query)
                    logger.info("added \(code.uppercased()): \(uname), link: \(ulink)")
                } catch {
                    logger.error("failed to update \(code.uppercased()) becase \(error)")
                }
            } else {
                let query = table.filter(uCode == code.uppercased()).delete()
                do {
                    try conn.run(query)
                    logger.info("deleted \(code.uppercased())")
                } catch {
                    logger.error("failed to delete \(code.uppercased())")
                }
            }
        
        }
    }

    /// This function retrieves the list of telegram group of which their unit code starts with the given prefix
    /// - Parameter prefix: prefix for unit code
    /// - Returns: A list of unit code
    func starts(with prefix:String) -> TgGroupsIterator {
        let (table, uCode, _, _) = db.getTelegramGroups()
        if prefix.isAlphanumeric {
            let query = table.select(uCode).filter(uCode.like(prefix+"%"))
            return TgGroupsIterator(rows: try? conn.prepare(query), column:uCode, count: try? conn.scalar(query.count))
        }
        return TgGroupsIterator(rows:nil, column:uCode, count:nil)
    }

    func makeIterator() -> TgGroupsIterator {
        let (table, uCode, _, _) = db.getTelegramGroups()
        let query = table.select(uCode)
        return TgGroupsIterator(rows: try? conn.prepare(query), column: uCode, count: try? conn.scalar(query.count))
    }

    /// Perform search on unit name
    /// - Paramter terms is a list of search terms
    func search(for terms:[String]) -> TgGroupsIterator {
        let (table, uCode, uName, _) = db.getTelegramGroups()
        let terms_ = terms.filter { (s: String) in s.count > 1 && s.isAlphanumeric } 
        guard terms_.count > 0 else {
            return TgGroupsIterator(rows:nil, column: uCode, count: nil)
        }
        var likes = uName.like("%" + terms_[0] + "%")
        for term in terms_[1...]{ 
            likes = likes || uName.like("%" + term + "%")
        }
        let query = table.select(uCode).filter(likes)
        return TgGroupsIterator(rows:try? conn.prepare(query), column: uCode, count: try? conn.scalar(query.count))
    }
}

