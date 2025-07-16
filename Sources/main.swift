// The Swift Programming Language
// https://docs.swift.org/swift-book

import Logging
import Foundation 

func main() {
    let logger = Logger(label:"main")
    let configFile = URL(string: FileManager().currentDirectoryPath)!.appendingPathComponent("config.json")
    if let config = try? AppConfig(from:configFile) {
        // setup database
        let db = config.getDatabase()
        let tg = TgGroups(db)
        tg["ict133"] = ("Structured Programming", "https://t.me/+91udwbtlw1hmYjE9")
        // tg["ict162"] = ("Object Oriented Programming", "https://t.me/+91udwbtlw1hmYjE9")
        if let (uname, link) = tg["ict133"] {
            print("ict133: \(uname) at \(link)")
            for code in tg.search(for:["struc"]) {
                print("search programming \(code) \(tg[code]!.0)")
            }
        }
        print("There are \(tg.count) ICT units")
    } else {
        logger.critical("failed to connect to database. please check \(configFile.absoluteString)")
    }
    logger.info("Exiting app")
}


main()
