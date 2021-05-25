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
    
    public var grid = [[CellView]]()
    
    var width:Int!
    var height:Int!
    var capacity:Int!
    var mines:Int!
    var drawDelegate:Drawable?
    var gameDelegate:GameStatusProtocol?
    var infoDelegate:GameInfoProtocol?
    var moveArray = [(Int, Int)]()
    var analyzeCachedCells = [CellView]()

    static let shared = GridModel()
    
    class func setup (width: Int,
                      height: Int,
                      mines: Int,
                      drawDelegate:Drawable?,
                      gameDelegate:GameStatusProtocol?,
                      infoDelegate:GameInfoProtocol?)
    {
        shared.width = width
        shared.height = height
        shared.mines = mines
        
        shared.drawDelegate = drawDelegate
        shared.gameDelegate = gameDelegate
        shared.infoDelegate = infoDelegate
        
        shared.generate()
    }
    
    public func generate () {
        
        moveArray = [(Int, Int)]()
        
        guard (width != nil), (height != nil), (mines != nil) else {
            fatalError("Error - you must call setup before accessing MySingleton.shared")
        }
        
        // перемешанный массив с минами и пустыми клетками
        
        capacity = width * height
        var shuffledArray = [cellType]()
        for i in 0...capacity-1 { shuffledArray.append( i < mines ? .mine : .clear) }
        shuffledArray.shuffle()
        
        // итоговая матица с минами и пустыми клетками
 
        grid = [[CellView]]()
        for x in 0...width-1 {
            grid.append([])
            for y in 0...height-1 {
                let flatPosition = x*height+y
                let type = shuffledArray[flatPosition]
                grid[x].append(CellView(type: type, position: (x,y), size: 30))
            }
        }
        
        cacheRegionsAround()
    }
    
    func cacheRegionsAround()
    {
        grid.enumerate { cell in
            cell.regionAround = [[nil]]
            cell.regionAround = regionAround(position: cell.position)
        }
    }
    
    private func regionAround(position:(Int,Int)) -> [[CellView?]]
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
    
    func isInsideGrid(point:(Int,Int)) -> Bool
    {
        let x = point.0
        let y = point.1
        let pointInsideGrid = (y >= 0 && y < grid.first!.count && x >= 0 && x < grid.count)
        return pointInsideGrid
    }
    
    func optimizeAnalyzeCahceCells()
    {
        var iterator = analyzeCachedCells.makeIterator()
        while let element = iterator.next() {
            let needToAnalyze = isNeedToAnalyze(cell: element)
            if needToAnalyze == false
            {
                analyzeCachedCells.remove(at: analyzeCachedCells.firstIndex(of: element)!)
            }
        }
    }
    
    func checkAllOpened()
    {
        var needToOpen = width * height - mines
        grid.enumerateOpened {
            if (!$0.isFlag()) {
                needToOpen -= 1
            }
        }
        if (needToOpen == 0) {
            gameDelegate?.gameOver(win: true)
        }
    }
    
}
