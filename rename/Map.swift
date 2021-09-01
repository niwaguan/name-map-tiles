//
//  Map.swift
//  rename
//
//  Created by Gaoyang on 2021/8/31.
//

import Foundation

struct Map {
    /// 当前缩放等级
    var scale: Int
    /// 该缩放等级下的瓦片数量
    var tiles: Int
    /// 正方形的边长
    var columns: Int

    var scaleOffset = 4
    
    init?(tiles: Int) {
        let side = sqrt(Double(tiles))
        let scale = Int(log2(side))
        
        let check = Int(truncating: NSDecimalNumber(decimal: pow(pow(2, scale), 2)))
        if (check != tiles) {
            return nil
        }
        self.columns = Int(side)
        self.scale = scale
        self.tiles = tiles
    }
    
    func name(of tile: Int, offsetX: Int = 0, y: Int = 0) -> String {
        let columns = self.columns
        let offsetSize = Int(truncating: NSDecimalNumber(decimal: pow(2, scale)))
        
        var line = tile / columns
        line += y * offsetSize
        
        var column = tile % columns
        column += offsetX * offsetSize
        
        let scale = scale + scaleOffset
        
        return "_\(scale)_\(column)_\(line)"
    }
}
