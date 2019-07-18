//
//  Analyzer.swift
//  MacMine
//
//  Created by Виктор on 14/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation
import Cocoa

let redColor = NSColor(red: 1, green: 0, blue: 0, alpha: 0.3)
let yellowColor = NSColor(red: 1, green: 1, blue: 0, alpha: 0.3)
let greenColor = NSColor(red: 0, green: 1, blue: 0, alpha: 0.3)

class Alazyler
{
    public class func analyze(gridModel:GridModel) -> Bool
    {
        var hasNewActions = false
        var newActions = 0
        repeat
        {
            let newMines = findMines(gridModel: gridModel)
            let newSafe = findSafe(gridModel: gridModel)
            let newUnknown = findAnother(gridModel: gridModel)
            newActions = newMines + newSafe + newUnknown
            if (newActions > 0) { hasNewActions = true }
        }
        while newActions > 0
        
        return hasNewActions
    }
    
    class func findMines (gridModel:GridModel) -> Int
    {
        var actions = 0
        
        gridModel.grid.enumerateOpened
        {
            let closedAround = gridModel.analyzeClosedAround(position:$0.position)
            if let string = $0.analyzeText(), let minesAround = Int(string)
            {
                if (minesAround == closedAround)
                {
                    var bombCell:CellView?
                    let regionAround = gridModel.regionAround(position: $0.position)
                    regionAround.enumerate {
                        if (!$0.isOpen() && !$0.isFlag()) { bombCell = $0 }
                    }
                    
                    if (bombCell != nil) {
                        if (!bombCell!.isAIMine())
                        {
                            bombCell?.setAIMine()
                            actions += 1
                        }
                    }
                }
            }
        }
        
        return actions
    }
    
    class func findSafe (gridModel:GridModel) -> Int
    {
        var actions = 0
        
        gridModel.grid.enumerateOpened
        {
            let AIOpenedMinesAround = gridModel.analyzeMinesAround(position:$0.position)
            if let string = $0.analyzeText(), let minesAround = Int(string)
            {
                if (minesAround == AIOpenedMinesAround)
                {
                    let regionAround = gridModel.regionAround(position: $0.position)
                    regionAround.enumerate {
                        if (!$0.isOpen() && !$0.isFlag() && !$0.isAIMine())
                        {
                            if (!$0.isAISafe())
                            {
                                actions += 1
                                $0.setAISafe()
                            }
                        }
                    }
                }
            }
        }
        
        return actions
    }
    
    class func findAnother (gridModel:GridModel) -> Int
    {
        var actions = 0
        
        gridModel.grid.enumerateOpened
        {
            let minesAround = gridModel.minesAround(position:$0.position)
            
            if (minesAround > 0)
            {
                let regionAround = gridModel.regionAround(position: $0.position)
                regionAround.enumerate {
                    if (!$0.isOpen() && !$0.isAIMine() && !$0.isAISafe())
                    {
                        if (!$0.isAIUnknown())
                        {
                            $0.setAIUnknown()
                            actions += 1
                        }
                    }
                }
            }
        }
        
        return actions
    }

}
