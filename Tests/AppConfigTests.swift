import Testing 
import Foundation 
import Logging 

@testable import sussmods_bot

struct AppConfigTests {
    let fm = FileManager.default
    
    @Test func MissingFileTest() async {
        let logger = Logger(label:"AppConfigTests:MissingFileTest")
        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/nosuchfile.json")
        let desc = "No config file"
        #expect(throws: AppConfigError.NoConfigFile(at:configFile)) {
            let _ = try AppConfig(from:configFile)
            logger.info("\(desc) fails to trigger error")
        } 
    }

    @Test func EmptyFileTest() async {
        let logger = Logger(label:"AppConfigTests:EmptyFileTest")

        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/empty.json")
        let desc = "Empty json file"
        #expect(throws: AppConfigError.EmptyFile(at: configFile)) {
            let _ = try AppConfig(from:configFile)
            logger.info("\(desc) fails to trigger error")
        }
    }

    @Test func EmptyFieldTest() async {
        let logger = Logger(label:"AppConfigTests:EmptyFieldTest")

        let c1 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad1.json")
        let desc1 = "Empty API Key"
        #expect(throws: AppConfigError.EmptyAPIKeyField) {
            let _ = try AppConfig(from:c1)
            logger.info("\(desc1) fails to triggers error")
        }

        let c2 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad2.json")
        let desc2 = "Empty Database"
        #expect(throws: AppConfigError.EmptyDatabaseField) {
            let _ = try AppConfig(from:c2)
            logger.info("\(desc2) fails to trigger error")
        }
    }

    @Test func BadJsonTest() async {
        let logger = Logger(label:"AppConfigTests:BadJsonTest")

        let c0 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad0.json")
        let desc0 = "Broken Syntax"
        #expect(throws: AppConfigError.BadJson(at:c0)) {
            let _ = try AppConfig(from:c0)
            logger.info("\(desc0) fails to trigger error")
        }

        let c3 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad3.json")
        let desc3 = "Missing APIKey field"
        #expect(throws:AppConfigError.BadJson(at: c3)) {
            let _ = try AppConfig(from:c3)
            logger.info("\(desc3) fails to trigger error")
        }

        let c4 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad4.json")
        let desc4 = "Missing Database field"
        #expect(throws:AppConfigError.BadJson(at:c4)) {
            let _ = try AppConfig(from:c4)
            logger.info("\(desc4) fails to trigger error")
        }

        let c5 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad5.json")
        let desc5 = "Malformed root"
        #expect(throws:AppConfigError.BadJson(at:c5)) {
            let _ = try AppConfig(from:c5)
            logger.info("\(desc5) failed to trigger error")
        }
    }

    @Test func GoodJsonTest() async {
        // let logger = Logger(label:"AppConfigTests:GoodJsonTest")

        let c0 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/good0.json")
        let desc0 = "Perfectly good Json"
        do {
            let a = try AppConfig(from:c0)
            #expect(a.APIKey == "1234","Wrong API Key")
            #expect(a.Database == "db.sqlite3", "Wrong database")
            #expect(a.Root.count == 1 && a.Root[0] == "geodome", "Wrong root")
        } catch {
            #expect(Bool(false), "\(desc0) triggers error")
        }

        let c1 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/good1.json")
        let desc1 = "Different order of fields"
        do {
            let a = try AppConfig(from:c1)
            #expect(a.APIKey == "1234", "Wrong API Key")
            #expect(a.Database == "db.sqlite3", "Wrong database")
            #expect(a.Root.count == 1 && a.Root[0] == "geodome", "Wrong root")
        } catch {
            #expect(Bool(false), "\(desc1) triggered error")
        }

        let c2 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/good2.json")
        let desc2 = "Extra fields"
        do {
            let a = try AppConfig(from:c2)
            #expect(a.APIKey == "1234", "Wrong API Key")
            #expect(a.Database == "db.sqlite3", "Wrong database")
            #expect(a.Root.count == 1 && a.Root[0] == "geodome", "Wrong root")
        } catch {
            #expect(Bool(false), "\(desc2) triggered error")
        }

    }
}


