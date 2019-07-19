//
//  MasterVC.swift
//  MacMine
//
//  Created by Виктор on 17/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation
import Cocoa

protocol GameStatusProtocol  {
    func newGame()
    func gameOver(win:Bool)
}

protocol GameInfoProtocol {
    func mineLabelIncrement()
    func mineLabelDecrement()
}

class MasterVC: NSViewController, GameStatusProtocol, GameInfoProtocol
{
    @IBOutlet weak var minesOpenInfolabel: NSTextField!
    @IBOutlet weak var filedOpenInfoLabel: NSTextField!
    
    @IBOutlet weak var minesProgres: NSProgressIndicator!
    @IBOutlet weak var fieldProgres: NSProgressIndicator!
    
    var minesOpened = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initUI() {
        minesOpenInfolabel.stringValue = "Новая игра"
        
        minesProgres.minValue = 0
        minesProgres.maxValue = Double(GridModel.sharedInstance.mines)
        minesProgres.doubleValue = 0
        
        fieldProgres.minValue = 0
        let capacity = GridModel.sharedInstance.height * GridModel.sharedInstance.width
        fieldProgres.maxValue = Double(capacity)
        fieldProgres.doubleValue = 0
    }
    
    func mineLabelIncrement() {
        minesOpened += 1
        updateInfo()
    }
    
    func mineLabelDecrement() {
        minesOpened -= 1
        updateInfo()
    }
    
    func updateInfo()
    {
        minesOpenInfolabel.stringValue = String(format: "Мины: %d / %d", minesOpened, GridModel.sharedInstance.mines)
        minesProgres.doubleValue = Double(minesOpened)
        
        let capacity = Double(GridModel.sharedInstance.height * GridModel.sharedInstance.width)
        let opened = Double(GridModel.sharedInstance.openedCells())
        let percent = opened / capacity * 100.0
        filedOpenInfoLabel.stringValue = String(format: "Поле: %.2f %%", percent)
        fieldProgres.doubleValue = Double(opened)
    }
    
    func newGame() {
        minesOpened = 0
        
        GridModel.sharedInstance.generate()
        
        initUI()
        
        GridModel.sharedInstance.draw()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            GridModel.sharedInstance.openZeroCell()
        })
    }
    
    func gameOver(win:Bool) {
        GridModel.sharedInstance.openMines(win: win)
        minesOpenInfolabel.stringValue = win ? "Победа!" : "Поражение!"
    }
    
    func AIPlay()
    {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            AIPlayer.playAnalyzed(gridModel: GridModel.sharedInstance, gameDelegate: self, infoDelegate: self)
            
            if (Alazyler.analyze(gridModel:GridModel.sharedInstance))
            {
                AIPlayer.playAnalyzed(gridModel: GridModel.sharedInstance, gameDelegate: self, infoDelegate: self)
                self.updateInfo()
            }
            else
            {
                timer.invalidate()
            }
        }
    }
    
    @IBAction func newGameAction(_ sender: Any) {
        newGame()
    }
    
    @IBAction func analyzeAction(_ sender: Any) {
        let _  = Alazyler.analyze(gridModel: GridModel.sharedInstance)
    }
    
    @IBAction func playAnalyzedAction(_ sender: Any) {
        AIPlayer.playAnalyzed(gridModel: GridModel.sharedInstance, gameDelegate: self, infoDelegate: self)
    }

    @IBAction func AIPlayAction(_ sender: Any)
    {
        AIPlay()
    }
    
    @IBAction func newGameWithAI(_ sender: Any) {
        newGame()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.AIPlay()
        })
    }
}
