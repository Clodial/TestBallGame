//
//  GameScene.swift
//  BallGame
//
//  Created by Matthew Maravilla on 6/2/15.
//  Copyright (c) 2015 Clodial. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.whiteColor()
        
        let LOGO = self.makeLogo("Logo1")
        self.addChild(LOGO)
        
        self.createMenuButtons("StartButton", aQuit: "QuitButton")
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
            }
            if locButton.name == "QuitButton"{
                exit(0)
            }
            
        }
    }
    
    func makeLogo(aNameOfLogo: String) -> SKSpriteNode{
        let locLogo = SKSpriteNode(imageNamed: aNameOfLogo)
        locLogo.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height - (locLogo.size.height * 2))
        return locLogo
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
