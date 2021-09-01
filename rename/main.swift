//
//  main.swift
//  rename
//
//  Created by Gaoyang on 2021/8/31.
//

import Foundation
import Logging
import Files
import ArgumentParser

//struct Repeat: ParsableCommand {
//    @Flag(help: "Include a counter with each repetition.")
//    var includeCounter = false
//
//    @Option(name: .shortAndLong, help: "The number of times to repeat 'phrase'.")
//    var count: Int?
//
//    @Argument(help: "The phrase to repeat.")
//    var phrase: String
//
//    mutating func run() throws {
//        let repeatCount = count ?? .max
//
//        for i in 1...repeatCount {
//            if includeCounter {
//                print("\(i): \(phrase)")
//            } else {
//                print(phrase)
//            }
//        }
//    }
//}

//Repeat.main()
// /Users/dockeruoo/Desktop/黎明觉醒地图/奥吉里岛

struct Name: ParsableCommand {
    
    enum NameError: Error {
        case invalidPath
        case invalidDestination
        case cannotCreateDestinationFolder
        case invalidTilesCount
    
    }
    
    @Option(name: .shortAndLong, help: "The tiles file path")
    var source: String = Files.Folder.current.path
    
    @Option(name: .short, help: "The x-axis value（0...15）.")
    var x: Int = 0
    @Option(name: .short, help: "The x-axis value（0...15）.")
    var y: Int = 0
    
    @Option(name: .shortAndLong, help: "The tiles file destination folder name")
    var destination: String = ""
    
    mutating func run() throws {
        guard source.count > 0 else {
            throw NameError.invalidPath
        }
        
        guard destination.count > 0 else {
            throw NameError.invalidDestination
        }
        
        print("processing path: \(source)")
        let sourceFolder = try Files.Folder(path: source)
        guard let destinationFolder = try? sourceFolder.parent?.createSubfolder(named: destination) else {
            throw NameError.cannotCreateDestinationFolder
        }
        
        print("目标文件夹：\(destinationFolder)")
        var count = 0
        try process(folder: sourceFolder, destination: destinationFolder, count: &count)
        
        print("done! total:\(count)")
    }
    
    func process(folder: Folder, destination: Folder, count: inout Int) throws {
        if folder.isEmpty() {
            return
        }
        
        // images
        let tiles = folder.files.filter { $0.extension == "png" }
        if tiles.count > 0 {
            guard let map = Map(tiles: tiles.count) else {
                throw NameError.invalidTilesCount
            }
            
            try tiles.enumerated().forEach { (index, element) in
                let name = map.name(of: index, offsetX: x, y: y)
                let file = try element.copy(to: destination)
                try file.rename(to: name)
                print("process \(element.path) -> \(file.path)")
            }
            print("info: scale:\(map.scale), total: \(map.tiles)")
            count += tiles.count
        }
        
        /// folders
        try folder.subfolders
            .forEach { folder in
            try process(folder: folder, destination: destination, count: &count)
        }
    }
    
}

Name.main()

