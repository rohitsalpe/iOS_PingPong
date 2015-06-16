//
//  GameOverScene.swift
//  PingPong
//
//  Created by Rohit on 4/28/15.
//  Copyright (c) 2015 Rohit. All rights reserved.
//
import SpriteKit

let GameOverLabelCategoryName = "gameOverLabel"

class GameOverScene: SKScene {
    var gameWon : Bool = false {
        // 1.
        didSet {
            let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as SKLabelNode
            gameOverLabel.text = gameWon ? "You Won!! Party!!" : "Game Over :( Try Again!! "
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let view = view {
            // 2.
            let gameScene = GameScene.unarchiveFromFile("GameScene") as GameScene
            view.presentScene(gameScene)
        }
        
       
    }
}

