import Logging
import SQLite
import Foundation

enum AppConfigError: Error {
    case BadJson
    case NoConfigFile
    case EmptyAPIKey
    case EmptyDatabase
    case EmptyFile
}

struct Config: Codable {
    var APIKey: String
    var Root: [String]
    var Database: String
}

// testing
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
        if let json = try? String(contentsOfFile: url.absoluteString) {
            guard json.count > 0 else {
                throw AppConfigError.EmptyFile
            }
            let jsonData = json.data(using: .utf8)!
            if let decoded = try? JSONDecoder().decode(Config.self, from: jsonData) {
                guard !decoded.APIKey.isEmpty else { 
                    logger.critical("Missing API Key")
                    throw AppConfigError.EmptyAPIKey 
                }
                guard !decoded.Database.isEmpty else { 
                    logger.critical("Missing Database File")
                    throw AppConfigError.EmptyDatabase 
                }
                config = decoded 
            } else {
                logger.critical("unable to decode \(url.absoluteString)")
                throw AppConfigError.BadJson
            }
        } else {
            logger.critical("unable to read \(url.absoluteString)")
            throw AppConfigError.NoConfigFile
        }
    }

    func getDatabaseConnection() -> Connection? {
        return try? Connection(Database) 
    }
}
