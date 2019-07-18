//
//  GridModel+Counter.swift
//  MacMine
//
//  Created by Виктор on 15/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation

extension GridModel
{
    public func minesCountIn(region:[[CellView?]]) -> Int
    {
        return region.flatMap { $0.filter { $0 != nil && $0!.type == .mine } }.count
    }
    
    public func minesAround(position:(Int,Int)) -> Int
    {
        let region = regionAround(position: position)
        let count = minesCountIn(region: region)
        return count
    }
    
    public func findZeroMineCell() -> CellView?
    {
        // находим все обасти где вокруг 0 мин
        
        var cells = [CellView?]()
        grid.enumerate {
            if (minesAround(position: $0.position) == 0)
            {
                cells.append($0)
            }
        }
        
        // берем медиану
        
        if (cells.count > 0) {
            let middleIndex = Int(cells.count / 2)
            return cells[middleIndex]
        } else {
            return nil
        }
    }
}
