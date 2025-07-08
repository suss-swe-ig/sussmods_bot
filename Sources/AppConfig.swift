import Logging
import SQLite
import Foundation

enum AppConfigError: Error {
    case BadJson
    case NoConfigFile
    case MissingAPIKey
    case MissingDatabase
}

struct Config: Codable {
    var APIKey: String
    var Root: [String]
    var Database: String
}

struct AppConfig {
    private var config: Config

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

    init(from url:URL) throws {
        let logger = Logger(label:"AppConfig")
        guard FileManager().fileExists(atPath: url.absoluteString) else { 
            logger.critical("Cannot find \(url.absoluteString)")
            throw AppConfigError.NoConfigFile
        }
        if let jsonData = try? String(contentsOfFile: url.absoluteString).data(using: .utf8), let decoded = try? JSONDecoder().decode(Config.self, from: jsonData) {
            guard !decoded.APIKey.isEmpty else { 
                logger.critical("Missing API Key")
                throw AppConfigError.MissingAPIKey 
            }
            guard !decoded.Database.isEmpty else { 
                logger.critical("Missing Database File")
                throw AppConfigError.MissingDatabase 
            }
            config = decoded 
        } else {
            logger.critical("unable to read or decode \(url.absoluteString)")
            throw AppConfigError.BadJson
        }
    }

    func getDatabaseConnection() -> Connection? {
        return try? Connection(Database) 
    }
}
