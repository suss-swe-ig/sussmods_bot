import Logging
import SQLite
import Foundation

enum AppConfigError: Error {
    case BadJson(at:URL)
    case NoConfigFile(at:URL)
    case EmptyAPIKeyField
    case EmptyDatabaseField
    case EmptyFile(at:URL)
    case CannotReadFile(at:URL)
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
        guard FileManager.default.fileExists(atPath: url.absoluteString) else { 
            logger.critical("Cannot find \(url.absoluteString)")
            throw AppConfigError.NoConfigFile(at:url)
        }
        if let json = try? String(contentsOfFile: url.absoluteString).data(using: .utf8) {
            guard json.count > 0 else {
                throw AppConfigError.EmptyFile(at:url)
            }
            if let decoded = try? JSONDecoder().decode(Config.self, from: json) {
                guard !decoded.APIKey.isEmpty else { 
                    logger.critical("Missing API Key")
                    throw AppConfigError.EmptyAPIKeyField
                }
                guard !decoded.Database.isEmpty else { 
                    logger.critical("Missing Database File")
                    throw AppConfigError.EmptyDatabaseField
                }
                config = decoded 
            } else {
                logger.critical("unable to decode \(url.absoluteString)")
                throw AppConfigError.BadJson(at:url)
            }
        } else {
            logger.critical("unable to read \(url.absoluteString)")
            throw AppConfigError.CannotReadFile(at:url)
        }
    }

    func getDatabaseConnection() -> Connection? {
        return try? Connection(Database) 
    }
}
