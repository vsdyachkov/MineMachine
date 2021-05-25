//
//  ImageView.swift
//  StackTest
//
//  Created by Viktor on 08/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation
import Cocoa

var flagSymbol = "⚑"

class CellView : NSImageView {
    
    var position = (0, 0)
    var regionAround = [[CellView?]]()
    var type:cellType = .clear
    var textLayer = CATextLayer()
    var colorLayer = CALayer()
    
    convenience init (type:cellType, position:(Int,Int), size:CGFloat)
    {
        self.init()
        
        self.type = type
        self.position = position
        self.frame = NSMakeRect(CGFloat(position.0)*size, CGFloat(position.1)*size, size, size)
        
        initUI()
    }
    
    func initUI() {
        self.image = NSImage(named: "clear")!
        
        textLayer.frame = self.bounds
        textLayer.fontSize = 24
        textLayer.alignmentMode = .center
        
        colorLayer.frame = self.bounds
        colorLayer.backgroundColor = .clear
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        GridModel.shared.leftClick(position: position)
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        super.rightMouseDown(with: theEvent)
        GridModel.shared.rightClick(position: position)
    }

}
