//
//  GameScene.swift
//  PingPong
//
//  Created by Rohit S on 4/28/15.
//  Copyright (c) 2015 Rohit. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let BlockNodeCategoryName = "blockNode"

let cnt = "counter"

import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \(filename)")
        
        return
    }
    
    var error: NSError? = nil
    backgroundMusicPlayer =
        AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var isFingerOnPaddle = false
    var counter = 0
    
    let BallCategory   : UInt32 = 0x1 << 0 // 0001
    let BottomCategory : UInt32 = 0x1 << 1 // 0010
    let BlockCategory  : UInt32 = 0x1 << 2 // 0100
    let PaddleCategory : UInt32 = 0x1 << 3 // 1000

    
    override func didMoveToView(view: SKView) {

         playBackgroundMusic("background_music.mp3")
        
        super.didMoveToView(view)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        let ball = childNodeWithName(BallCategoryName) as SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(10, -12))

        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let paddle = childNodeWithName(PaddleCategoryName) as SKSpriteNode
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        
 
        ball.physicsBody!.contactTestBitMask = BottomCategory
        paddle.physicsBody!.contactTestBitMask = BallCategory
        
        physicsWorld.contactDelegate = self
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // 1. Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        // 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
            counter++
            let gameOverLabel1 = childNodeWithName(cnt) as SKLabelNode
            gameOverLabel1.text = String(counter)
            
            runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
            
            if counter == 10
            {
               backgroundMusicPlayer.stop()

                
                if let mainView = view {
                    let gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as GameOverScene
                    gameOverScene.gameWon = true
                    mainView.presentScene(gameOverScene)
                }
            }
        }
        

        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
               backgroundMusicPlayer.stop()
            if let mainView = view {
                let gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as GameOverScene
                gameOverScene.gameWon = false
                mainView.presentScene(gameOverScene)
            }
        }
    
        
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)

        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == PaddleCategoryName {
                isFingerOnPaddle = true
            }
        }
        
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {

        if isFingerOnPaddle {
            let touch = touches.anyObject() as UITouch
            let touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            var paddle = childNodeWithName(PaddleCategoryName) as SKSpriteNode
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)

            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        isFingerOnPaddle = false
    }
    
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
  //  }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
