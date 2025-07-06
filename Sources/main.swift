// The Swift Programming Language
// https://docs.swift.org/swift-book

import SQLite

func main() {
    if let config = getAppConfig() {
        // setup database
        let db = config.getDatabaseConnection()
        let tg = TgGroups(conn:db!)
        tg["ict133"] = ("Structured Programming", "https://t.me/+91udwbtlw1hmYjE9")
        tg["ict162"] = ("Object Oriented Programming", "https://t.me/+91udwbtlw1hmYjE9")
        print(config)
    } else {
        print("Exiting app")
    }
}

main()
