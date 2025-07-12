import Testing 
import Foundation 
import Logging 

@testable import sussmods_bot

struct AppConfigTests {
    let fm = FileManager()
    
    @Test func MissingFileTest() {
        let logger = Logger(label:"AppConfigTests:MissingFileTest")
        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/nosuchfile.json")
        let desc = "No config file"
        do {
            let _ = try AppConfig(from:configFile)
            logger.info("\(desc) triggers no error")
        } catch AppConfigError.NoConfigFile {
            logger.info("\(desc) detected")
            #expect(true)
        } catch {
            logger.info("\(desc) not detected")
            #expect(Bool(false), "unknown error \(error)")
        } 
    }

    @Test func EmptyFileTest() {
        let logger = Logger(label:"AppConfigTests:EmptyFileTest")

        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/empty.json")
        let desc = "Empty json file"
        do {
            let _ = try AppConfig(from:configFile)
            logger.info("\(desc) triggers no error")
        } catch AppConfigError.EmptyFile {
            logger.info("\(desc) detected")
            #expect(true)
        } catch {
            logger.info("\(desc) not detected")
            #expect(Bool(false), Comment(stringLiteral:"empty config file"))
        } 
    }

    @Test func EmptyFieldTest() {
        let logger = Logger(label:"AppConfigTests:EmptyFieldTest")

        let c1 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad1.json")
        let desc1 = "Empty API Key"
        do {
            let _ = try AppConfig(from:c1)
            logger.info("\(desc1) triggers no error")
        } catch AppConfigError.EmptyAPIKey {
            logger.info("\(desc1) detected")
            #expect(true)
        } catch {
            logger.info("\(desc1) not detected")
            #expect(Bool(false), Comment(stringLiteral: desc1))
        }
        let c2 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad2.json")
        let desc2 = "Empty Database"
        do {
            let _ = try AppConfig(from:c2)
            logger.info("\(desc2) triggers no error")
        } catch AppConfigError.EmptyDatabase {
            logger.info("\(desc2) detected")
            #expect(true)
        } catch {
            logger.info("\(desc2) not detected")
            #expect(Bool(false), Comment(stringLiteral: desc2))
        }

    }

    @Test func BadJsonTest() {
        let logger = Logger(label:"AppConfigTests:BadJsonTest")

        let c0 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad0.json")
        let desc0 = "Broken Syntax"
        do {
            let _ = try AppConfig(from:c0)
        } catch AppConfigError.BadJson {
            logger.info("\(desc0) detected")
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral: desc0))
        }
        let c3 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad3.json")
        let desc3 = "Missing APIKey field"
        do {
            let _ = try AppConfig(from:c3)
        } catch AppConfigError.BadJson {
            logger.info("\(desc3) detected")
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral:desc3))
        }
        let c4 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad4.json")
        let desc4 = "Missing Database field"
        do {
            let _ = try AppConfig(from:c4)
        } catch AppConfigError.BadJson {
            logger.info("\(desc4) detected")
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral:desc4))
        }
        let c5 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad5.json")
        let desc5 = "Malformed root"
        do {
            let _ = try AppConfig(from:c5)
            logger.info("\(desc5) not detected")
        } catch AppConfigError.BadJson {
            logger.info("\(desc5) detected")
            #expect(true)
        } catch {
            logger.info("\(desc5) not detected")
            #expect(Bool(false), Comment(stringLiteral:desc5 + " \(error)"))
        }
    }

    @Test func GoodJsonTest() {
        let logger = Logger(label:"AppConfigTests:GoodJsonTest")

        let c0 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/good0.json")
        let desc0 = "Malformed root"
        do {
            let a = try AppConfig(from:c0)
            #expect(a.APIKey == "1234", Comment(stringLiteral: "Wrong API Key"))
            #expect(a.Database == "db.sqlite3", Comment(stringLiteral: "Wrong database"))
            #expect(a.Root.count == 1 && a.Root[0] == "geodome", Comment(stringLiteral:"Wrong root"))
        } catch {
            logger.info("\(desc0) triggered error")
            #expect(Bool(false))
        }

        let c1 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/good1.json")
        let desc1 = "Different order of fields"
        do {
            let a = try AppConfig(from:c1)
            #expect(a.APIKey == "1234", Comment(stringLiteral: "Wrong API Key"))
            #expect(a.Database == "db.sqlite3", Comment(stringLiteral: "Wrong database"))
            #expect(a.Root.count == 1 && a.Root[0] == "geodome", Comment(stringLiteral:"Wrong root"))
        } catch {
            logger.info("\(desc1) triggered error")
            #expect(Bool(false))
        }

        let c2 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/good2.json")
        let desc2 = "Extra fields"
        do {
            let a = try AppConfig(from:c2)
            #expect(a.APIKey == "1234", Comment(stringLiteral: "Wrong API Key"))
            #expect(a.Database == "db.sqlite3", Comment(stringLiteral: "Wrong database"))
            #expect(a.Root.count == 1 && a.Root[0] == "geodome", Comment(stringLiteral:"Wrong root"))
        } catch {
            logger.info("\(desc2) triggered error")
            #expect(Bool(false))
        }

    }
}


