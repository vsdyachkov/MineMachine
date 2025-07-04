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
            setExplosedBomb(cell: cell)
            return
        } else {
            openCell(cell: cell)
        }
    }
    
    public func rightClick(position:(Int,Int))
    {
        let cell = grid[position.0][position.1]
        
        if (!cell.isOpen()) {
            setFlag(cell: cell)
        } else if (cell.isFlag()) {
            removeFlag(cell: cell)
        } else {
            openAround(position: cell.position)
            GridModel.shared.moveArray.append(cell.position)
            infoDelegate?.updateInfo(openedCells: openedCells(), moves: GridModel.shared.moveArray)
            checkAllOpened()
            optimizeAnalyzeCahceCells()
        }
    }
    
    public func openCell(cell:CellView) {
        let mines = minesAround(position: cell.position)
        cell.setNumberText(num: mines)
        GridModel.shared.analyzeCachedCells.append(cell)
        GridModel.shared.moveArray.append(cell.position)
        
        if (mines == 0) {
            openAround(position: cell.position)
        }
        
        infoDelegate?.updateInfo(openedCells: openedCells(), moves: GridModel.shared.moveArray)
        checkAllOpened()
        optimizeAnalyzeCahceCells()
    }
    
    public func setFlag(cell:CellView) {
        cell.setFlagText()
    }
    
    public func removeFlag(cell:CellView) {
        cell.textLayer.string = nil
    }
    
    public func setExplosedBomb(cell:CellView) {
        cell.setExplosedBombText()
        GridModel.shared.moveArray.append(cell.position)
        gameDelegate?.gameOver(win: false)
    }
}
