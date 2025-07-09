import Testing 
import Foundation 

@testable import sussmods_bot

struct AppConfigTests {
    let fm = FileManager()

    @Test func MissingFileTest() {
        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/nosuchfile.json")
        do {
            let _ = try AppConfig(from:configFile)
        } catch AppConfigError.NoConfigFile {
            #expect(true)
        } catch {
            #expect(Bool(false), "unknown error \(error)")
        } 
    }

    @Test func EmptyFileTest() {
        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/empty.json")
        do {
            let _ = try AppConfig(from:configFile)
        } catch AppConfigError.EmptyFile {
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral:"empty config file"))
        } 
    }

    @Test func EmptyFieldTest() {
        let c1 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad1.json")
        let desc1 = "Empty API Key"
        do {
            let _ = try AppConfig(from:c1)
        } catch AppConfigError.EmptyAPIKey {
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral: desc1))
        }
        let c2 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad2.json")
        let desc2 = "Empty Database"
        do {
            let _ = try AppConfig(from:c2)
        } catch AppConfigError.EmptyDatabase {
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral: desc2))
        }

    }

    @Test func BadJsonTest() {
        let c0 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad0.json")
        let desc0 = "Broken Syntax"
        do {
            let _ = try AppConfig(from:c0)
        } catch AppConfigError.BadJson {
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral: desc0))
        }
        let c3 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad3.json")
        let desc3 = "Missing APIKey field"
        do {
            let _ = try AppConfig(from:c3)
        } catch AppConfigError.BadJson {
            #expect(true)
        } catch {
            #expect(Bool(false), Comment(stringLiteral:desc3))
        }
        let c4 = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad4.json")
        let desc4 = "Missing Database field"
        do {
            let _ = try AppConfig(from:c4)
        } catch AppConfigError.BadJson {
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

}


