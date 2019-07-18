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
    
    var delegate: Clickable?
    var position = (0, 0)
    var type:cellType = .clear
    var textLayer = CATextLayer()
    var colorLayer = CALayer()
    
    convenience init (type:cellType, position:(Int,Int), size:CGFloat, delegate:Clickable?)
    {
        self.init()
        
        self.type = type
        self.position = position
        self.delegate = delegate
        self.image = NSImage(named: "clear")!
        
        self.frame = NSMakeRect(CGFloat(position.0)*size, CGFloat(position.1)*size, size, size)
        
        textLayer.frame = self.bounds
        textLayer.fontSize = 24
        textLayer.alignmentMode = .center
        
        colorLayer.frame = self.bounds
        colorLayer.backgroundColor = .clear
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        delegate?.click(cell: self, isLeftMouse:true)
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        super.rightMouseDown(with: theEvent)
        delegate?.click(cell: self, isLeftMouse:false)
    }

}
