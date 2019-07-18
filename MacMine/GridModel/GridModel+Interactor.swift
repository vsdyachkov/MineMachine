//
//  GridModel+Interactor.swift
//  MacMine
//
//  Created by Viktor on 17/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation

extension GridModel
{
    public func leftClick(position:(Int,Int))
    {
        let cell = grid[position.0][position.1]
        
        if (cell.isFlag()) {
            return
        } else if (cell.isMine()) {
            cell.setBombText()
            gameDelegate?.gameOver(win: false)
            return
        } else {
            let mines = minesAround(position: position)
            cell.setNumberText(num: mines)
            checkAllOpened()
            if (mines == 0) {
                openAround(position: cell.position)
            }
            checkAllOpened()
        }
        
//        cell.setCellColor(color: .clear)
    }
    
    public func rightClick(position:(Int,Int))
    {
        let cell = grid[position.0][position.1]
        
        if (!cell.isOpen()) {
            cell.setFlagText()
            infoDelegate?.mineLabelIncrement()
        } else if (cell.isFlag()) {
            cell.textLayer.string = nil
            infoDelegate?.mineLabelDecrement()
        } else {
            openAround(position: cell.position)
            checkAllOpened()
        }
        
//        cell.setCellColor(color: .clear)
    }
    
    
    
    
}
