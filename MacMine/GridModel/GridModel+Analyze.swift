//
//  GridModel+Analyze.swift
//  MacMine
//
//  Created by Виктор on 16/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation

extension GridModel
{
    func isAnalyzeOpen(cell:CellView?) -> Bool
    {
        let isOpen = cell != nil && cell!.isOpen() && !cell!.isFlag()
        return isOpen
    }
    
    public func anazlyzeOpenedAround(position:(Int,Int)) -> Int
    {
        let region = regionAround(position: position)
        return region.flatMap { $0.filter { isAnalyzeOpen(cell:$0) } }.count
    }
    
    public func analyzeClosedAround(position:(Int,Int)) -> Int
    {
        return 9 - anazlyzeOpenedAround(position: position)
    }
    
    public func analyzeMinesAround(position:(Int,Int)) -> Int
    {
        let region = regionAround(position: position)
        let mines = region.flatMap { $0.filter { $0 != nil && $0!.isAIMine() } }.count
        return mines
    }
}
