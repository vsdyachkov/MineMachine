//
//  CellView+Decorator.swift
//  MacMine
//
//  Created by Виктор on 15/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation
import Cocoa

extension CellView
{
    public func setBombText() { setText(text: "💣") }
    public func setExplosedBombText() { setText(text: "💥") }
    public func setFlagText() { setText(text: "⚑") }
    public func setNumberText(num:Int) {
        setText(text: String(num))
//        info
        
    }
    func isMine() -> Bool { return type == .mine }
    
    
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
        
        if (layer != nil)
        {
            if !((layer?.sublayers?.contains(textLayer))!) {
                self.layer?.addSublayer(textLayer)
            }
        }
        
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
}
