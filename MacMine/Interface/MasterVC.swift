//
//  MasterVC.swift
//  MacMine
//
//  Created by Виктор on 17/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation
import Cocoa

protocol GameOverable  {
    func gameOver(win:Bool)
}

protocol GameInfoProtocol {
    func mineLabelIncrement()
    func mineLabelDecrement()
}

class MasterVC: NSViewController, GameOverable, GameInfoProtocol
{
    @IBOutlet weak var label: NSTextField!
    
    var minesOpened = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        newGame()
    }
    
    func mineLabelIncrement() {
        minesOpened += 1
//        label.stringValue = String(format: "%d / %d", minesOpened, mines)
    }
    
    func mineLabelDecrement() {
        minesOpened -= 1
//        label.stringValue = String(format: "%d / %d", minesOpened, mines)
    }
    
    func newGame() {
        label.stringValue = "Новая игра"
        minesOpened = 0
        
        GridModel.sharedInstance.draw(view:view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            GridModel.sharedInstance.openZeroCell()
        })
    }
    
    @IBAction func pushButton(_ sender: Any) {
        newGame()
    }
    
    func gameOver(win:Bool) {
        GridModel.sharedInstance.openMines(win: win)
        label.stringValue = win ? "Победа!" : "Поражение!"
    }
    
    @IBAction func helpAction(_ sender: Any) {
        let _  = Alazyler.analyze(gridModel: GridModel.sharedInstance)
    }
    
    @IBAction func AIPlayAction(_ sender: Any)
    {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            AIPlayer.playAnalyzed(gridModel: GridModel.sharedInstance, gameDelegate: self, infoDelegate: self)
            
            if (Alazyler.analyze(gridModel:GridModel.sharedInstance))
            {
                AIPlayer.playAnalyzed(gridModel: GridModel.sharedInstance, gameDelegate: self, infoDelegate: self)
            }
            else
            {
                timer.invalidate()
                print("End!")
            }
        }
    }
}
