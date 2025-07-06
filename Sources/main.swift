// The Swift Programming Language
// https://docs.swift.org/swift-book

import Logging

func main() {
    let logger = Logger(label:"main")
    if let config = getAppConfig(), let db = config.getDatabaseConnection() {
        // setup database
        let tg = TgGroups(conn:db)
        tg["ict133"] = ("Structured Programming", "https://t.me/+91udwbtlw1hmYjE9")
        tg["ict162"] = ("Object Oriented Programming", "https://t.me/+91udwbtlw1hmYjE9")
        print(config)
    } else {
        logger.error("failed to connect to database. please check comfig.json")
        logger.info("Exiting app")
    }
}

main()
