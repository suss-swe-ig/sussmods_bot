// The Swift Programming Language
// https://docs.swift.org/swift-book

import SQLite

func main() {
    let db = try? Connection("db.sqlite3")
    let tg = TgGroups(conn:db!)
}

main()
