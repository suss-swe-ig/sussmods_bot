import Logging
import SQLite
import Foundation

struct AppConfig: Codable {
    var APIKey: String
    var Root: [String]
    var Database: String
    func getDatabaseConnection() -> Connection? {
        return try? Connection(Database)
    }
}

func getAppConfig(url:URL) -> AppConfig? {
    let logger = Logger(label:"getAppConfig")
    do {
        if let jsonData = try String(contentsOfFile: url.absoluteString).data(using: .utf8), let decoded = try? JSONDecoder().decode(AppConfig.self, from: jsonData) {
            logger.info("successfully decoded \(url.absoluteString)")
            return decoded
        }
        logger.error("Fail to decode \(url.absoluteString)")
        return nil
    } catch {
        logger.error("unable to read \(url.absoluteString)")
        logger.error("\(error)")
        return nil
    }
}