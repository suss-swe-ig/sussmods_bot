// The Swift Programming Language
// https://docs.swift.org/swift-book

import Logging
import Foundation 

func main() {
    let logger = Logger(label:"main")
    let configFile = URL(string:FileManager().currentDirectoryPath)!.appendingPathComponent("config.json")
    if let config = getAppConfig(url:configFile), let db = config.getDatabaseConnection() {
        // setup database
        let tg = TgGroups(conn:db)
        tg["ict133"] = ("Structured Programming", "https://t.me/+91udwbtlw1hmYjE9")
        tg["ict162"] = ("Object Oriented Programming", "https://t.me/+91udwbtlw1hmYjE9")
        print(config)
    } else {
        logger.error("failed to connect to database. please check config.json")
        logger.info("Exiting app")
    }
}


main()
