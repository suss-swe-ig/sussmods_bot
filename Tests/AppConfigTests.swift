import Testing 
import Foundation 
import Logging 

@testable import sussmods_bot

struct AppConfigTests {
    let fm = FileManager()
    let logger = Logger(label:"AppConfigTests")

    @Test func MissingFileTest() {
        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/nosuchfile.json")
        let desc = "No config file"
        do {
            let _ = try AppConfig(from:configFile)
            logger.info("MissingFileTest: \(desc) triggers no error")
        } catch AppConfigError.NoConfigFile {
            logger.info("MissingFileTest: \(desc) detected")
            #expect(true)
        } catch {
            logger.info("MissingFileTest: \(desc) not detected")
            #expect(Bool(false), "unknown error \(error)")
        } 
    }

    @Test func EmptyFileTest() {
        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/empty.json")
        let desc = "Empty json file"
        do {
            let _ = try AppConfig(from:configFile)
            logger.info("EmptyFileTest: \(desc) triggers no error")
        } catch AppConfigError.EmptyFile {
            logger.info("EmptyfileTest: \(desc) detected")
            #expect(true)
        } catch {
            logger.info("EmptyFileTest: \(desc) not detected")
            #expect(Bool(false), Comment(stringLiteral:"empty config file"))
        } 
    }

    @Test func EmptyFieldTest() {
        let c1 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad1.json")
        let desc1 = "Empty API Key"
        do {
            let _ = try AppConfig(from:c1)
            logger.info("EmptyFieldTest: \(desc1) triggers no error")
        } catch AppConfigError.EmptyAPIKey {
            logger.info("EmptyFieldTest: \(desc1) detected")
            #expect(true)
        } catch {
            logger.info("EmptyFieldTest: \(desc1) not detected")
            #expect(Bool(false), Comment(stringLiteral: desc1))
        }
        let c2 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad2.json")
        let desc2 = "Empty Database"
        do {
            let _ = try AppConfig(from:c2)
            logger.info("EmptyFieldTest: \(desc2) triggers no error")
        } catch AppConfigError.EmptyDatabase {
            logger.info("EmptyFieldTest: \(desc2) detected")
            #expect(true)
        } catch {
            logger.info("EmptyFieldTest: \(desc2) not detected")
            #expect(Bool(false), Comment(stringLiteral: desc2))
        }

    }

    @Test func BadJsonTest() {
        let c0 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad0.json")
        let desc0 = "Broken Syntax"
        do {
            let _ = try AppConfig(from:c0)
        } catch AppConfigError.BadJson {
            logger.info("BadJsonTest: \(desc0) detected")
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral: desc0))
        }
        let c3 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad3.json")
        let desc3 = "Missing APIKey field"
        do {
            let _ = try AppConfig(from:c3)
        } catch AppConfigError.BadJson {
            logger.info("BadJsonTest: \(desc3) detected")
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral:desc3))
        }
        let c4 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad4.json")
        let desc4 = "Missing Database field"
        do {
            let _ = try AppConfig(from:c4)
        } catch AppConfigError.BadJson {
            logger.info("BadJsonTest: \(desc4) detected")
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral:desc4))
        }
        let c5 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad5.json")
        let desc5 = "Malformed root"
        do {
            let a = try AppConfig(from:c5)
            #expect(a.Root.count == 0)
        } catch AppConfigError.BadJson {
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral:desc5 + " \(error)"))
        }
    }

    @Test func goodJsonTest() {

    }
}


