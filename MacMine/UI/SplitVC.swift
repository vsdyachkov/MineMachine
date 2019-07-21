//
//  SplitVC.swift
//  MacMine
//
//  Created by Виктор on 17/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation
import Cocoa

class SplitVC: NSSplitViewController
{
    let width = 30
    let height = 20
    let mines = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let master = self.splitViewItems[0].viewController as! MasterVC
        let detail = self.splitViewItems[1].viewController as! DetailVC
        
        GridModel.setup(width: width, height: height, mines: mines,
                        drawDelegate: detail,
                        gameDelegate: master,
                        infoDelegate: master)
        
        master.newGame(){}
    }
    
}
