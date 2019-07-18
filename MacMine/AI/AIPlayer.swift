//
//  AIPlayer.swift
//  MacMine
//
//  Created by Viktor on 17/07/2019.
//  Copyright © 2019 Виктор. All rights reserved.
//

import Foundation

class AIPlayer
{
    class public func playAnalyzed(gridModel:GridModel, gameDelegate:GameOverable?, infoDelegate:GameInfoProtocol?)
    {
        gridModel.grid.enumerate
        {
            if ($0.isAIMine())
            {
                if (!$0.isFlag())
                {
                    gridModel.rightClick(position: $0.position)
                }
            }
            else if ($0.isAISafe())
            {
                gridModel.leftClick(position: $0.position)
            }
        }
    }
}
