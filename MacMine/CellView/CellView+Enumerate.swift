//
//  CellView+enumerate.swift
//  MacMine
//
//  Created by Виктор on 15/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation

extension Array where Element == Array<CellView?> {
    
    func enumerate(_ action:(CellView) -> ()) {
        for row in self {
            for item in row {
                if (item != nil) {
                    action(item!)
                }
            }
        }
    }
}

extension Array where Element == Array<CellView> {
    
    func enumerate(_ action:(CellView) -> ()) {
        for row in self {
            for item in row {
                action(item)
            }
        }
    }
    
    func enumerateOpened(_ action:(CellView) -> ()) {
        for row in self {
            for item in row {
                if (item.isOpen()) {
                    action(item)
                }
            }
        }
    }
}
