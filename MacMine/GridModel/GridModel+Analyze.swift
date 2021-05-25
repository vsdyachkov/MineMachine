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
        let isOpen = cell == nil ||
            (cell!.isOpen() &&
            !cell!.isFlag())
        return isOpen
    }
    
    public func anazlyzeOpenedAround(position:(Int,Int)) -> Int
    {
        let cell = grid[position.0][position.1]
        let region = cell.regionAround;
        return region.flatMap { $0.filter { isAnalyzeOpen(cell:$0) } }.count
    }
    
    public func analyzeClosedAround(position:(Int,Int)) -> Int
    {
        return 9 - anazlyzeOpenedAround(position: position)
    }
    
    public func analyzeMinesAround(position:(Int,Int)) -> Int
    {
        let cell = grid[position.0][position.1]
        let region = cell.regionAround;
        let mines = region.flatMap { $0.filter { $0 != nil && ($0!.isAIMine() || $0!.isFlag()) } }.count
        return mines
    }
    
    public func isNeedToAnalyze(cell:CellView) -> Bool
    {
        let countToOpen = cell.regionAround.flatMap { $0.filter {
            $0 != nil &&
            !$0!.isOpen() &&
            !$0!.isAIMine() &&
            !$0!.isAISafe() &&
            !$0!.isFlag() } }.count
        
        var isNeedToAnalyze = true
        if countToOpen == 0 {
            isNeedToAnalyze = false
        }
        
        return isNeedToAnalyze
    }
}
