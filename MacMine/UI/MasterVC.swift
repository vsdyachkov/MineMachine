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
    func gameOver(win:Bool, position:(Int, Int))
}

extension GameStatusProtocol {
    // optional parameter
    func gameOver(win:Bool, position:(Int, Int) = (0,0)) {
        gameOver(win: win, position: position)
    }
}

protocol GameInfoProtocol {
    func updateInfo(openedCells: (Int, Int))
}

class MasterVC: NSViewController, GameStatusProtocol, GameInfoProtocol
{
    @IBOutlet weak var filedOpenInfoLabel: NSTextField!
    @IBOutlet weak var fieldProgres: NSProgressIndicator!
    
    @IBOutlet weak var statusLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initUI() {
        statusLabel.stringValue = "Игра в процессе"
        
        fieldProgres.minValue = 0
        let capacity = GridModel.sharedInstance.capacity
        fieldProgres.maxValue = Double(capacity!)
        fieldProgres.doubleValue = 0
        filedOpenInfoLabel.stringValue = String(format: "Открыто: 0 %%")
    }
    
    func updateInfo(openedCells: (Int, Int)) {
        let percent = Double(openedCells.0) / Double(openedCells.1) * 100.0
        filedOpenInfoLabel.stringValue = String(format: "Открыто: %.0f %%", percent)
        fieldProgres.doubleValue = Double(openedCells.0)
    }
    
    func newGame() {
        GridModel.sharedInstance.generate()
        
        initUI()
        
        GridModel.sharedInstance.draw()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            GridModel.sharedInstance.openZeroCell()
        })
    }
    
    func gameOver(win:Bool, position:(Int, Int)) {
        GridModel.sharedInstance.openMines(win: win, position:position)
        statusLabel.stringValue = win ? "Победа!" : "Поражение!"
    }
    
    func AIPlay()
    {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            AIPlayer.playAnalyzed(gridModel: GridModel.sharedInstance, gameDelegate: self, infoDelegate: self)
            
            if (Alazyler.analyze(gridModel:GridModel.sharedInstance))
            {
                AIPlayer.playAnalyzed(gridModel: GridModel.sharedInstance, gameDelegate: self, infoDelegate: self)
//                self.updateInfo()
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
