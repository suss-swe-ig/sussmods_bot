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

func getAppConfig(filename:String = "config.json") -> AppConfig? {
    let logger = Logger(label:"getAppConfig")
    do {
        if let jsonData = try String(contentsOfFile: filename).data(using: .utf8) {
            let decoded = try JSONDecoder().decode(AppConfig.self, from: jsonData) 
            logger.info("successfully decoded \(filename)")
            return decoded
        }
        logger.error("Fail to decode \(filename)")
        return nil
    } catch {
        logger.error("unable to read \(filename)")
        return nil
    }
}