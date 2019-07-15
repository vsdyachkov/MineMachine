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
    public class func analyze(gridModel:GridModel)
    {
        let _ = findMines(gridModel: gridModel)
        let _ = findSafe(gridModel: gridModel)
        let _ = findAnother(gridModel: gridModel)
    }
    
    class func findMines (gridModel:GridModel) -> Int
    {
        var actions = 0
        
        gridModel.grid.enumerate {
            if ($0.isOpen()) {
                let closedAround = gridModel.closedAround(position:$0.position)
                let minesAround = gridModel.minesAround(position:$0.position)
                
                if (minesAround > 0 && minesAround == closedAround)
                {
                    var bombCell:CellView?
                 
                    let regionAround = gridModel.regionAround(position: $0.position)
                    regionAround.enumerate {
                        if (!$0.isOpen() && !$0.isFlag()) { bombCell = $0 }
                    }
                    
                    if (bombCell != nil) {
                        bombCell!.setCellColor(color: redColor)
                        actions += 1
                    }
                }
            }
        }
        
        return actions
    }
    
    class func findSafe (gridModel:GridModel) -> Int
    {
        var actions = 0
        
        gridModel.grid.enumerate {
            if ($0.isOpen()) {
                let openedMinesAround = gridModel.AIMinesAround(position:$0.position)
                let minesAround = gridModel.minesAround(position:$0.position)
                
                if (minesAround > 0 && minesAround == openedMinesAround)
                {
                    let regionAround = gridModel.regionAround(position: $0.position)
                    regionAround.enumerate {
                        if (!$0.isOpen() && !$0.isFlag() && !$0.isAIMine())
                        {
                            $0.setCellColor(color: greenColor)
                            actions += 1
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
        
        gridModel.grid.enumerate {
            if ($0.isOpen()) {
                let minesAround = gridModel.minesAround(position:$0.position)
                
                if (minesAround > 0)
                {
                    let regionAround = gridModel.regionAround(position: $0.position)
                    regionAround.enumerate {
                        if (!$0.isOpen() && !$0.isAIMine() && !$0.isAISafe())
                        {
                            $0.setCellColor(color: yellowColor)
                            actions += 1
                        }
                    }
                }
            }
        }
        
        return actions
    }

}
