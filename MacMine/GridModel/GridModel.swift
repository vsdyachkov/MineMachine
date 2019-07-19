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
    var mines:Int!
    var drawDelegate:Drawable?
    var clickDelegate:Clickable?
    var gameDelegate:GameStatusProtocol?
    var infoDelegate:GameInfoProtocol?

    static let sharedInstance = GridModel()
    
    class func setup (width: Int,
                      height: Int,
                      mines: Int,
                      drawDelegate:Drawable?,
                      clickDelegate:Clickable?,
                      gameDelegate:GameStatusProtocol?,
                      infoDelegate:GameInfoProtocol?)
    {
        sharedInstance.width = width
        sharedInstance.height = height
        sharedInstance.mines = mines
        
        sharedInstance.drawDelegate = drawDelegate
        sharedInstance.clickDelegate = clickDelegate
        sharedInstance.gameDelegate = gameDelegate
        sharedInstance.infoDelegate = infoDelegate
        
        sharedInstance.generate()
    }
    
    public func generate () {
        
        guard (width != nil), (height != nil), (mines != nil) else {
            fatalError("Error - you must call setup before accessing MySingleton.shared")
        }
        
        // перемешанный массив с минами и пустыми клетками
        
        let capacity = width * height
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
                let cell = CellView(type: type, position: (x,y), size: 30, delegate: clickDelegate)
                grid[x].append(cell)
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
    
    func isInsideGrid(point:(Int,Int)) -> Bool
    {
        let x = point.0
        let y = point.1
        let pointInsideGrid = (y >= 0 && y < grid.first!.count && x >= 0 && x < grid.count)
        return pointInsideGrid
    }
    
    func checkAllOpened()
    {
        var needToOpen = width * height - mines
        grid.enumerateOpened {
            if (!$0.isFlag()) {
                needToOpen -= 1
            }
        }
        if (needToOpen == 0) { gameDelegate?.gameOver(win: true) }
    }
    
}
