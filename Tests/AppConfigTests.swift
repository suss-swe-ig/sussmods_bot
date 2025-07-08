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
            #expect(false, "unknown error \(error)")
        } 
    }

    @Test func EmptyFileTest() {
        let configFile = URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/empty.json")
        do {
            let _ = try AppConfig(from:configFile)
        } catch AppConfigError.EmptyFile {
            #expect(true)
        } catch {
            #expect(false, "unknown error")
        } 
    }

    @Test func BadJsonTest() {
        let c0 = (URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad0.json"), "Broken Syntax")
        let c1 = (URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad1.json"), "Missing API Key")
        let c2 = (URL(string:fm.currentDirectoryPath)!.appendingPathComponent("Tests/bad2.json"), "Misspelled API Key")
        for (cfile, desc) in [c0, c1, c2] {
            do {
                let _ = try AppConfig(from:cfile)
            } catch AppConfigError.BadJson {
                #expect(true)
            } catch {
                #expect(false, "\(desc)")
            } 
        }
    }

    @Test func NoAPIKeyTest() {

    }
}


