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
}


