import Testing 
import Foundation 
import Logging 
import SQLite

@testable import sussmods_bot

struct TgGroupsTest {

    func with(url:URL, logger:Logger, closure: () -> Void) {
        if FileManager.default.fileExists(atPath: url.absoluteString) {
            do {
                try FileManager.default.removeItem(at:url)
                logger.info("start of test: removed \(url)")
            } catch {
                logger.info("start of test: failed to remove \(url) because \(error)")
            }
        }
        closure()
        do {
            try FileManager.default.removeItem(at:url)
            logger.info("end of test: removed \(url)")
        } catch {
            logger.info("end of test: failed to remove \(url) because \(error)")
        }
    }
    
    @Test func EmptyTest() {
        let logger = Logger(label:"TgGroupsTest:EmptyTest")
        let url = URL(string: "file://" + FileManager.default.currentDirectoryPath)!.appendingPathComponent("Tests/test.sqlite3")
        with(url:url, logger:logger) { () in 
            let db = try! Connection(url.absoluteString)
            let test = TgGroups(conn:db)

            if let (uname, link) = test["ict133"] {
                #expect(Bool(false), Comment(stringLiteral:"Empty database yields \(uname) and \(link)"))
            } else {
                #expect(Bool(true), Comment(stringLiteral: "Empty database yields nil"))
            }

            let searchResult = test.search(for: ["ict133"])
            for ucode in searchResult {
                logger.info("detected non-nil search result")
                #expect(Bool(false), Comment(stringLiteral:"Empty database yields non-nil search result \(ucode)"))
            }
            #expect(searchResult.count == 0, Comment(stringLiteral:"Empty database yields 0 search result"))
        }
    }

    @Test func DataTest() {
        let logger = Logger(label:"TgGroupsTest:DataTest")
        let url = URL(string: "file://" + FileManager.default.currentDirectoryPath)!.appendingPathComponent("Tests/db.sqlite3")

        let table = Table("telegram_groups")
        let uCode = Expression<String>("unit_code")
        let uName = Expression<String>("unit_name")
        let link = Expression<String>("link")

        let testData = [
            ("ICT114", "Computer Architecture", "https://t.me/ict114"),
            ("ICT133", "Structured Programming", "https://t.me/ict133"),
            ("ICT162", "Object Oriented Programming", "https://t.me/ict162"),
            ("ICT235", "Data Structures and Algorithms", "https://t.me/ict235"),
            ("ICT325", "Design and Analysis of Algorithms", "https://t.me/ict325"),
            ("ICT233", "Data Programming", "https://t.me/ict233"),
            ("ICT239", "Web Programming", "https://t.me/ict239"),
            ("ICT246", "Operating Systems", "https://t.me/ict246"),
            ("ICT259", "Computer Networking", "https://t.me/ict259"),
            ("ICT323", "Parallel Computing", "https://t.me/ict323"),
            ("ICT318", "Network Security", "https://t.me/ict318"),
            ("MTH105", "Fundamentals of Mathematics", "https://t.me/mth105"),
            ("MTH109", "Calculus", "https://t.me/mth109"),
            ("MTH207", "Linear Algebra", "https://t.me/mth207"),
            ("MTH208", "Advanced Linear Algebra", "https://t.me/mth208"),
            ("MTH210", "Fundamentals of Probability", "https://t.me/mth210"),
            ("MTH212", "Statistical Analysis", "https://t.me/mth212"),
            ("MTH240", "Engineering Mathematics One", "https://t.me/mth240"),
            ("MTH321", "Engineering Mathematics Two", "https://t.me/mth321"),
            ("MTH316", "Multivariable Calculus", "https://t.me/mth316"),
            ("MTH318", "Advanced Calculus", "https://t.me/mth318"),
            ("MTH312", "Real Analysis One", "https://t.me/mth312"),
            ("MTH314", "Real Analysis Two", "https://t.me/mth314"),
            ("MTH355", "Basic Mathematical Optimisation", "https://t.me/mth355"),
            ("MTH356", "Advanced Mathematical Optimisation", "https://t.me/mth356"),
            ("MTH367", "Network Optimisation and Modelling", "https://t.me/mth367"),
        ]

        with(url:url, logger:logger) { () in 
            // create database
            guard let db = try? Connection(url.absoluteString) else {
                logger.error("failed to create database \(url.absoluteString)")
                #expect(Bool(false))
                return
            }
            do {
                // create table
                try db.execute(table.create { (t:TableBuilder) in
                    t.column(uCode, primaryKey: true)
                    t.column(uName)
                    t.column(link)
                    logger.info("created table telegram_groups")
                })
                // insert test data
                for (ucode, uname, ulink) in testData {
                    let query = table.insert(uCode <- ucode, uName <- uname, link <- ulink)
                    guard let _ = try? db.run(query) else {
                        logger.error("failed to insert test data for \(ucode) into database")
                        return
                    }
                }
                logger.info("inserted test data successfully")
                // begin testing
                let test = TgGroups(conn:db)

                // check ict114
                let ucode = "ict114"
                if let (uname, ulink) = test[ucode] {
                    #expect(uname == "Computer Architecture", "Wrong unit name for \(ucode)")
                    #expect(ulink == "https://t.me/ict114", "Wrong telegram link for \(ucode)")
                } else {
                    #expect(Bool(false), "Unable to fetch correct data for \(ucode)")
                }

                // update unit name
                if let (_, ulink1) = test["ict133"] {
                    test["ict133"] = ("Structured Programming with Python", ulink1)
                }
                if let (uname2, ulink2) = test["ict133"] {
                    #expect(uname2 == "Structured Programming with Python", "wrong unit name after update")
                    #expect(ulink2 == "https://t.me/ict133", "wrong link after update")
                }

                // update unit name and link
                if let _ = test["ict162"] {
                    test["ict162"] = ("Object Oriented Programming with Python", "https://t.me/ict162_")
                }
                if let (uname3, ulink3) = test["ict162"] {
                    #expect(uname3 == "Object Oriented Programming with Python", "wrong unit name after update")
                    #expect(ulink3 == "https://t.me/ict162_", "wrong link after update")
                }

                // search for python 
                let searchResult = test.search(for:["python"])
                let searchResultList = searchResult.toList()
                #expect(searchResult.count == 2, "Wrong count for search result")
                #expect(searchResultList.contains("ICT133") && searchResultList.contains("ICT162"), "Wrong search result")

                // delete unit
                let (uname4, ulink4) = test["mth105"]!
                test["mth105"] = nil
                if let _ = test["mth105"] {
                    #expect(Bool(false), "Failed to delete MTH105")
                } else {
                    #expect(Bool(true))
                    test["mth105"] = (uname4, ulink4)
                }

                // list all ICT units
                let ict = test.starts(with:"ict")
                let mth = test.starts(with:"mth")
                #expect(ict.count + mth.count == testData.count, "wrong count")
                let ictList = ict.toList()
                let correctResult =  ["ICT114", "ICT133", "ICT162", "ICT233", "ICT239", "ICT246", "ICT259", "ICT235", "ICT325", "ICT323", "ICT318"]
                #expect(ict.count == correctResult.count, "wrong count of ICT mods")
                for ucode in correctResult {
                    #expect(ictList.contains(ucode), "Missing unit \(ucode) in ict list")
                }
            } catch {
                logger.error("\(error)")
                return
            }
        }
    }
}