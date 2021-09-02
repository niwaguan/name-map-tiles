//
//  Logger.swift
//  rename
//
//  Created by Gaoyang on 2021/9/2.
//

import Foundation
import Logging
import SwiftyBeaver
import LoggingSwiftyBeaver

class Logger {
    
    static let worker = Logging.Logger(label: "com.gaonengshike.map") { label in
        SwiftyBeaver.LogHandler(label, destinations: [])
    }
    
    static let consoleDestination: ConsoleDestination = {
        let d = ConsoleDestination()
        d.format = "$DHH:mm:ss$d $L $M"
        return d
    }()
    static func makeConsoleLoggerEnabled(_ enabled: Bool) {
        if enabled {
            SwiftyBeaver.addDestination(consoleDestination)
        } else {
            SwiftyBeaver.removeDestination(consoleDestination)
        }
    }
    
    static let fileDestination: FileDestination = {
        let d = FileDestination(logFileURL: nil)
        d.format = "$DHH:mm:ss$d $L $M"
        // 开启异步会导致文件无法写完
        d.asynchronously = false
        return d
    }()
    static func updateLoggerFilaPath(_ path: String) {
        if let _ = fileDestination.logFileURL {
            SwiftyBeaver.removeDestination(fileDestination)
        }
        fileDestination.logFileURL = URL(fileURLWithPath: path)
        SwiftyBeaver.addDestination(fileDestination)
    }
    
    static func log(_ message: String, repeatInConsole: Bool = false) {
        worker.info(Logging.Logger.Message(stringLiteral: message))
        if repeatInConsole {
            print(message)
        }
    }
}
