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
    func newGame(completion: @escaping () -> Void)
    func gameOver(win:Bool)
}

protocol GameInfoProtocol {
    func updateInfo(openedCells: (Int, Int), moves:[(Int, Int)])
}

class MasterVC: NSViewController, GameStatusProtocol, GameInfoProtocol
{
    @IBOutlet weak var filedOpenInfoLabel: NSTextField!
    @IBOutlet weak var fieldProgres: NSProgressIndicator!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var playedGameLabel: NSTextFieldCell!
    @IBOutlet weak var averagePercentLabel: NSTextField!
    @IBOutlet weak var sliderLabel: NSTextField!
    @IBOutlet weak var moveSlider: NSSliderCell!
    
    var percentArray = [Double]()
    var isAutoPlay:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initUI() {
        statusLabel.stringValue = "Игра в процессе"
        
        fieldProgres.minValue = 0
        let capacity = GridModel.shared.capacity
        fieldProgres.maxValue = Double(capacity!)
        fieldProgres.doubleValue = 0
        filedOpenInfoLabel.stringValue = String(format: "Открыто: 0 %%")
    }
    
    func updateInfo(openedCells: (Int, Int), moves:[(Int, Int)]) {
        let percent = Double(openedCells.0) / Double(openedCells.1) * 100.0
        filedOpenInfoLabel.stringValue = String(format: "Открыто: %.0f %%", percent)
        fieldProgres.doubleValue = Double(openedCells.0)
        
        moveSlider.minValue = 0
        moveSlider.maxValue = Double(moves.count)
        moveSlider.altIncrementValue = 1
        moveSlider.doubleValue = Double(moves.count)
        moveSlider.drawTickMarks()
        sliderLabel.stringValue = String(format: "Ход: %d / %d", moves.count, moves.count)
    }
    
    func newGame(completion: @escaping () -> Void) {
        GridModel.shared.generate()
        
        initUI()
        
        GridModel.shared.draw()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            GridModel.shared.openZeroCell()
            completion()
        })
    }
    
    func gameOver(win:Bool) {
        GridModel.shared.openMines(win: win)
        statusLabel.stringValue = win ? "Победа!" : "Поражение!"
    }
    
    func AIPlay()
    {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            AIPlayer.playAnalyzed(gridModel: GridModel.shared, gameDelegate: self, infoDelegate: self)
            
            if (Alazyler.analyze(gridModel:GridModel.shared))
            {
                AIPlayer.playAnalyzed(gridModel: GridModel.shared, gameDelegate: self, infoDelegate: self)
            }
            else
            {
                timer.invalidate()
                let openedCells = GridModel.shared.openedCells()
                let percent = Double(openedCells.0) / Double(openedCells.1) * 100.0
                self.percentArray.append(percent)
                let average = self.percentArray.reduce(0, { $0 + $1 }) / Double(self.percentArray.count)
                self.averagePercentLabel.stringValue = String(format: "В среднем: %.0f %%", average)
                self.playedGameLabel.stringValue = String(format: "Сыграно: %d", self.percentArray.count)
                
                if (self.isAutoPlay) {
                    self.newGame {
                        self.AIPlay()
                    }
                }
            }
        }
    }
    
//    ##MARK: 2
    
    @IBAction func newGameAction(_ sender: Any) {
        newGame(){}
    }
    
    @IBAction func analyzeAction(_ sender: Any) {
        let _  = Alazyler.analyze(gridModel: GridModel.shared)
    }
    
    @IBAction func playAnalyzedAction(_ sender: Any) {
        AIPlayer.playAnalyzed(gridModel: GridModel.shared, gameDelegate: self, infoDelegate: self)
    }

    @IBAction func AIPlayAction(_ sender: Any) {
        AIPlay()
    }
    
    @IBAction func newGameWithAI(_ sender: Any) {
        newGame() {}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.AIPlay()
        })
    }
    
    @IBAction func autoPlayAction(_ sender: Any) {
        isAutoPlay = true
        AIPlay()
    }
    
    @IBAction func stopAutoPlayAction(_ sender: Any) {
        isAutoPlay = false
    }
}
