//
//  DetailVC.swift
//  StackTest
//
//  Created by Виктор on 08/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Cocoa

protocol Clickable {
    func click(cell:CellView, isLeftMouse:Bool)
}

class DetailVC: NSViewController, Clickable
{
    func click(cell: CellView, isLeftMouse: Bool)
    {
        if (isLeftMouse)
        {
            GridModel.sharedInstance.leftClick(position: cell.position)
        }
        else
        {
            GridModel.sharedInstance.rightClick(position: cell.position)
        }
    }
}

