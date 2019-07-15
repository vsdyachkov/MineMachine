//
//  GridModel.swift
//  StackTest
//
//  Created by Viktor on 08/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation
import Cocoa

public enum cellType {
    case clear
    case mine
}

class GridModel {
    
    var grid = [[CellView]]()
    
    let width:Int!
    let height:Int!
    let mines:Int!

    init(width:Int, height:Int, mines:Int, delegate:Clickable?) {
        
        self.width = width
        self.height = height
        self.mines = mines
        
        // перемешанный массив с минами и пустыми клетками
        
        let capacity = width * height
        var shuffledArray = [cellType]()
        for i in 0...capacity { shuffledArray.append( i < mines ? .mine : .clear) }
        shuffledArray.shuffle()
        
        // итоговая матица с минами и пустыми клетками
 
        for x in 0...width-1 {
            grid.append([])
            for y in 0...height-1 {
                let flatPosition = x*height+y
                let type = shuffledArray[flatPosition]
                let cell = CellView(type: type, position: (x,y), size: 30, delegate: delegate)
                grid[x].append(cell)
            }
        }
    }
    
    public func draw(view:NSView) {
        
        // очистка от старых CellView
        
        for currentView in view.subviews {
            if (currentView.isKind(of: CellView.self)) {
                currentView.removeFromSuperview()
            }
        }
        
        // отрисовка
 
        for x in 0...grid.count-1 {
            for y in 0...grid[x].count-1 {
                view.addSubview(grid[x][y])
            }
        }
    }
    
    public func regionAround(position:(Int,Int)) -> [[CellView?]]
    {
        var region = [[CellView?]]()
        
        for y in stride(from:position.1+1, to:position.1-2, by:-1) {
            var row = [CellView?]()
            for x in position.0-1...position.0+1 {
                let pointInsideGrid = isInsideGrid(point: (x,y))
                row.append(pointInsideGrid ? grid[x][y] : nil)
            }
            region.append(row)
        }
        
//        for row in region { print (row.map({$0.self == nil ? "・" : $0 == .mine ? "☒" : "☐"})) }
        
        return region
    }
    
    public func minesAround(position:(Int,Int)) -> Int
    {
        let region = regionAround(position: position)
        let count = minesCountIn(region: region)
        return count
    }
    
    public func openedAround(position:(Int,Int)) -> Int
    {
        let region = regionAround(position: position)
        return region.flatMap {
            $0.filter {
                $0 != nil &&
                $0!.isOpen() &&
                !$0!.isFlag()
            }
            }.count
    }
    
    public func closedAround(position:(Int,Int)) -> Int
    {
        return 9 - openedAround(position: position)
    }
    
    public func AIMinesAround(position:(Int,Int)) -> Int
    {
        let region = regionAround(position: position)
        let mines = region.flatMap { $0.filter { $0 != nil && $0!.isAIMine() } }.count
        return mines
    }
    
    public func openAround(position:(Int,Int), delegate:GameOverable?)
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
                            delegate?.gameOver(win: false)
                            return
                        } else {
                            cell.setNumberText(num: count)
                            cell.colorLayer.backgroundColor = .clear
                        }
                        if (count == 0) { openAround(position:(x,y), delegate: delegate) }
                    }
                }
            }
        }
    }
    
    public func openMines(win:Bool)
    {
        grid.enumerate {
            if ($0.type == .mine) {
                win ? $0.setBombText() : $0.setExplosedBombText() 
            } else {
                let count = minesAround(position: $0.position)
                $0.setNumberText(num: count)
            }
        }
    }
    
    private func minesCountIn(region:[[CellView?]]) -> Int
    {
        return region.flatMap { $0.filter { $0 != nil && $0!.type == .mine } }.count
    }
    
    func isInsideGrid(point:(Int,Int)) -> Bool
    {
        let x = point.0
        let y = point.1
        let pointInsideGrid = (y >= 0 && y < grid.first!.count && x >= 0 && x < grid.count)
        return pointInsideGrid
    }
    
    func checkAllOpened(delegate: GameOverable?)
    {
        var needToOpen = width * height - mines
        grid.enumerate {if ($0.isOpen() && !$0.isFlag()) { needToOpen -= 1 } }
        if (needToOpen == 0) { delegate?.gameOver(win: true) }
    }
    
}
