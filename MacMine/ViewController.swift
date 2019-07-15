//
//  ViewController.swift
//  StackTest
//
//  Created by Виктор on 08/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Cocoa

protocol Clickable {
    func click(cell:CellView, isLeftMouse:Bool)
}

protocol GameOverable  {
    func gameOver(win:Bool)
}

class ViewController: NSViewController, Clickable, GameOverable
{
    let width = 10
    let height = 10
    let mines = 10
    
    var gridModel:GridModel!
    var minesOpened = 0
    
    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }
    
    @IBAction func pushButton(_ sender: Any) {
        newGame()
    }
    
    func newGame() {
        label.stringValue = "Новая игра"
        minesOpened = 0
        gridModel = GridModel(width: width, height: height, mines: mines, delegate: self)
        gridModel.draw(view:view)
    }
    
    func gameOver(win:Bool) {
        gridModel.openMines(win: win)
        label.stringValue = win ? "Победа!" : "Поражение!"
    }

    func click(cell: CellView, isLeftMouse: Bool)
    {
        let minesAround = gridModel.minesAround(position: cell.position)
        
        if (isLeftMouse) {
            if (cell.isFlag()) {
                return
            } else if (cell.isMine()) {
                cell.setBombText()
                gameOver(win: false)
                return
            } else {
                cell.setNumberText(num: minesAround)
                gridModel.checkAllOpened(delegate: self)
                if (minesAround == 0) {
                    gridModel.openAround(position: cell.position, delegate: self)
                }
                gridModel.checkAllOpened(delegate: self)
            }
        } else {
            if (!cell.isOpen()) {
                cell.setFlagText()
                minesOpened += 1
                label.stringValue = String(format: "%d / %d", minesOpened, mines)
            } else if (cell.isFlag()) {
                cell.textLayer.string = nil
                minesOpened -= 1
                label.stringValue = String(format: "%d / %d", minesOpened, mines)
            } else {
                gridModel.openAround(position: cell.position, delegate: self)
                gridModel.checkAllOpened(delegate: self)
            }
        }
    }
    
    @IBAction func helpAction(_ sender: Any) {
        Alazyler.analyze(gridModel:gridModel)
    }
}

