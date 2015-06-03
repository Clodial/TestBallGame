//
//  EndGameScene.swift
//  BallGame
//
//  Created by Matthew Maravilla on 6/2/15.
//  Copyright (c) 2015 Clodial. All rights reserved.
//

import Foundation
import SpriteKit
import Darwin

class EndGameScene : SKScene{
    
    init(size: CGSize , aScore: Int){
        super.init(size: size)
        
        self.backgroundColor = SKColor.whiteColor()
        
        self.makeLabel("Logo1",aScoreWrite: aScore)
        
        self.createMenuButtons("StartButton", aQuit: "QuitButton")
    }
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch in (touches as! Set<UITouch>){
            let locLocation = touch.locationInNode(self)
            let locButton = nodeAtPoint(locLocation)
            
            if locButton.name == "StartButton" {
                let locReveal = SKTransition.fadeWithDuration(0.5)
                let locMainGameScene = MainGameScene(size:self.size)
                self.view?.presentScene(locMainGameScene, transition:locReveal)
            }else if locButton.name == "QuitButton"{
                exit(0)
            }
            
        }
    }
    
    func makeLabel(aNameOfLogo: String , aScoreWrite: Int){
        let locLabel = SKLabelNode(fontNamed: "Avenir-Book")
        locLabel.fontSize = 50
        locLabel.fontColor = UIColor.blackColor()
        locLabel.text = "Final Score: \(aScoreWrite)"
        
        locLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height - (locLabel.frame.size.height * 2))
        self.addChild(locLabel)
    }
    func createMenuButtons(aStart: String, aQuit: String){
        
        let locStartButton = SKSpriteNode(imageNamed: aStart)
        let locQuitButton = SKSpriteNode(imageNamed: aQuit)
        
        locStartButton.name = "StartButton"
        locQuitButton.name = "QuitButton"
        
        locStartButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        locQuitButton.position = locStartButton.position
        locQuitButton.position.y -= (locQuitButton.size.height * 2)
        
        self.addChild(locStartButton)
        self.addChild(locQuitButton)
    }

    
}