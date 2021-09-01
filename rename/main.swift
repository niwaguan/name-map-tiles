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
    
    @Option(name: .short, help: "The name prefix. eg prefix_z_x_y .")
    var prefix: String = ""
    
    @Option(name: .shortAndLong, help: "The tiles file destination folder name")
    var destination: String = ""
    
    mutating func run() throws {
        guard source.count > 0 else {
            throw NameError.invalidPath
        }
        
        guard destination.count > 0 else {
            throw NameError.invalidDestination
        }
        
        print("start process at path: \(source)")
        let sourceFolder = try Files.Folder(path: source)
        guard let destinationFolder = try? sourceFolder.parent?.createSubfolder(named: destination) else {
            throw NameError.cannotCreateDestinationFolder
        }
        
        var count = 0
        try process(folder: sourceFolder, destination: destinationFolder, count: &count)
        
        print("\n✅done!")
        print("total: \(count)")
        print("destination：\(destinationFolder.path)")
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
            
            try tiles
                .sorted(by: { l, r in
                    guard let leftNumberString = l.nameExcludingExtension.split(separator: "_").last,
                          let rightNumberString = r.nameExcludingExtension.split(separator: "_").last,
                          let leftNumber = Int(leftNumberString),
                          let rightNumber = Int(rightNumberString)
                    else {
                        return l.nameExcludingExtension < r.nameExcludingExtension
                    }
                    return leftNumber < rightNumber
                })
                .enumerated()
                .forEach { (index, element) in
                
                let name = prefix + map.name(of: index, offsetX: x, y: y)
                let file = try element.copy(to: destination)
                try file.rename(to: name)
                print("- index: \(index)\t\(element.path) ->\t\(file.path)")
            }
            print("* statistics: scale:\(map.scale), total: \(map.tiles)")
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

//Counter.main()
