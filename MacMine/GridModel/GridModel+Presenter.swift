//
//  GridModel+Interface.swift
//  MacMine
//
//  Created by Виктор on 15/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation
import Cocoa

extension GridModel
{
    public func draw() {
        
        // очистка от старых CellView
        
        if let subviews = drawDelegate?.view.subviews
        {
            var iterator = subviews.makeIterator()
            while let element = iterator.next() {
                if (element.isKind(of: CellView.self)) {
                    element.removeFromSuperview()
                }
            }
        }
        else
        {
            return;
        }
        
        // отрисовка
        
        for x in 0...grid.count-1 {
            for y in 0...grid[x].count-1 {
                let cell = grid[x][y]
                drawDelegate?.view.addSubview(cell)
            }
        }
    }
    
    public func openZeroCell()
    {
        if let cell = findZeroMineCell()
        {
            openAround(position: cell.position)
        }
        infoDelegate?.updateInfo(openedCells: openedCells(), moves: GridModel.shared.moveArray)
        checkAllOpened()
    }
    
    public func openAround(position:(Int,Int))
    {
        for y in stride(from:position.1+1, to:position.1-2, by:-1) {
            for x in position.0-1...position.0+1 {
                if (isInsideGrid(point: (x,y)))
                {
                    let cell = grid[x][y]
                    if (cell.textLayer.string == nil)
                    {
                        let count = minesCountIn(region: grid[x][y].regionAround)
                        if (cell.type == .mine) {
                            cell.setBombText()
                            gameDelegate?.gameOver(win: false)
                            return
                        } else {
                            cell.setNumberText(num: count)
                            GridModel.shared.analyzeCachedCells.append(cell)
                        }
                        if (count == 0) { openAround(position:(x,y)) }
                    }
                }
            }
        }
    }
    
    public func openMines(win:Bool)
    {
        grid.enumerate {
            if ($0.type == .mine) {
                if (win) {
                    $0.setBombText()
                } else {
                    $0.setExplosedBombText()
                }
            } else {
                let count = minesAround(position: $0.position)
                $0.setNumberText(num: count)
            }
        }
    }
    
}
