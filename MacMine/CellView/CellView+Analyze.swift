//
//  CellView+Logic.swift
//  MacMine
//
//  Created by Виктор on 15/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation

extension CellView
{
    public func analyzeText() -> String? { return textLayer.string as? String }
    func isFlag() -> Bool { return textLayer.string as? String == flagSymbol }
    func isOpen() -> Bool { return textLayer.string != nil }
    
    func isAIMine() -> Bool     { return cellColor() == redColor }
    func isAISafe() -> Bool     { return cellColor() == greenColor }
    func isAIUnknown() -> Bool  { return cellColor() == yellowColor }
    
    func setAIMine() { setCellColor(color: redColor) }
    func setAISafe() { setCellColor(color: greenColor) }
    func setAIUnknown() { setCellColor(color: yellowColor) }
}
