import Logging
import SQLite
import Foundation

enum AppConfigError: Error {
    case BadJson
}

struct Config: Codable {
    var APIKey: String
    var Root: [String]
    var Database: String
}

struct AppConfig {
    var config: Config

    var APIKey: String {
        get {
            config.APIKey
        }
    }

    var Root: [String] {
        get {
            config.Root
        }
    }

    var Database: String {
        get {
            config.Database
        }
    }

    init(url:URL) throws {
        let logger = Logger(label:"AppConfig")
        if let jsonData = try? String(contentsOfFile: url.absoluteString).data(using: .utf8), let decoded = try? JSONDecoder().decode(Config.self, from: jsonData) {
            config = decoded
            logger.info("successfully decoded \(url.absoluteString)")
        } else {
            logger.error("unable to read or decode \(url.absoluteString)")
            throw AppConfigError.BadJson
        }
    }

    func getDatabaseConnection() -> Connection? {
        return try? Connection(Database) 
    }
}
