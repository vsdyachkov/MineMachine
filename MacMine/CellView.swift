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
    
    public func setCellColor(color:NSColor) {
        colorLayer.backgroundColor = color.cgColor
        if !((layer?.sublayers?.contains(colorLayer))!) {
            self.layer?.addSublayer(colorLayer)
        }
    }
    
    public func cellColor() -> NSColor
    {
        return NSColor(cgColor:(colorLayer.backgroundColor!))!
    }
    
    public func setBombText() { setText(text: "💣") }
    public func setExplosedBombText() { setText(text: "💥") }
    public func setFlagText() { setText(text: "⚑") }
    public func setNumberText(num:Int) { setText(text: String(num)) }
    public func getNumberText() -> String? { return textLayer.string as? String }
    
    private func setText(text:String)
    {
        let is0 = (text == "0")
        textLayer.string = is0 ? "" : text
        textLayer.backgroundColor = is0 ? NSColor(white: 0, alpha: 0.1).cgColor : .clear
        colorLayer.backgroundColor = is0 ? .clear : colorLayer.backgroundColor
        
        var foregroundColor = CGColor.black
        switch text {
        case "💥": foregroundColor = NSColor.red.cgColor
        case "⚑": foregroundColor = NSColor.red.cgColor
        case "1": foregroundColor = NSColor.blue.cgColor
        case "2": foregroundColor = NSColor(red: 0, green: 0.5, blue: 0, alpha: 1).cgColor
        case "3": foregroundColor = NSColor.red.cgColor
        case "4": foregroundColor = NSColor(red: 0, green: 0, blue: 0.3, alpha: 1).cgColor
        case "5": foregroundColor = NSColor.brown.cgColor
        case "6": foregroundColor = NSColor(red: 0, green: 0.4, blue: 0.4, alpha: 1).cgColor
        case "8": foregroundColor = NSColor.lightGray.cgColor
        default: foregroundColor = NSColor.black.cgColor
        }
        
        textLayer.foregroundColor = foregroundColor
        
        if !((layer?.sublayers?.contains(textLayer))!) {
            self.layer?.addSublayer(textLayer)
        }
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
