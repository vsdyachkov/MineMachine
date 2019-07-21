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
        
        for currentView in (drawDelegate?.view.subviews)! {
            if (currentView.isKind(of: CellView.self)) {
                currentView.removeFromSuperview()
            }
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
        infoDelegate?.updateInfo(openedCells: openedCells())
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
                        let count = minesCountIn(region: regionAround(position: (x,y)))
                        if (cell.type == .mine) {
                            cell.setBombText()
                            gameDelegate?.gameOver(win: false, position:position)
                            return
                        } else {
                            cell.setNumberText(num: count)
                            cell.colorLayer.backgroundColor = .clear
                        }
                        if (count == 0) { openAround(position:(x,y)) }
                    }
                }
            }
        }
    }
    
    public func openMines(win:Bool, position:(Int, Int))
    {
        grid.enumerate {
            if ($0.type == .mine) {
                let isExplosedBomb = !win && $0.position == position
                if (isExplosedBomb) {
                    $0.setExplosedBombText()
                } else {
                    $0.setBombText()
                }
            } else {
                let count = minesAround(position: $0.position)
                $0.setNumberText(num: count)
            }
        }
    }
    
}
