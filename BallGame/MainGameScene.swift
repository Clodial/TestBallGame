//
//  MainGameScene.swift
//  BallGame
//
//  Created by Matthew Maravilla on 6/2/15.
//  Copyright (c) 2015 Clodial. All rights reserved.
//

import Foundation
import SpriteKit

var COLORTYPE : [UIColor] = [UIColor.yellowColor(),UIColor.blueColor(),UIColor.redColor(),UIColor.greenColor(),UIColor.orangeColor(),UIColor.purpleColor(), UIColor.brownColor(), UIColor.darkGrayColor(), UIColor.magentaColor(), UIColor.whiteColor()]

struct PhysicsCollision{
    static let BallCat : UInt32 = 0b1
}

class MainGameScene: SKScene, SKPhysicsContactDelegate{
    
    var mScore : Int = 0
    var mTime : Int = 10
    
    var mFirstMaster : Int = Int(arc4random_uniform(UInt32(COLORTYPE.count)))
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.gravity = CGVectorMake(0,0)
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = SKColor.whiteColor()
        
        scene!.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        self.createMaster(COLORTYPE[mFirstMaster])
        self.createGameContainer()
        self.createLabels()
        self.createBalls(COLORTYPE.count)
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(runTimer),
            SKAction.waitForDuration(1.0)
            ])
        ))
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>){
            let locLocation = touch.locationInNode(self)
            let locBall = nodeAtPoint(locLocation)
            
            if locBall.name == "Ball"{
                let locCheckBall = locBall as? SKShapeNode
                let locMast = self.childNodeWithName("MasterColor") as? SKShapeNode
                
                if locCheckBall?.fillColor == locMast?.fillColor{
                    mScore += 1
                    mTime += 5
                }else{
                    mScore -= 1
                    mTime -= 10
                }
                locBall.physicsBody?.applyImpulse(CGVectorMake(random(-10,max:10)*0.75,random(-10,max:10)*0.75))
                locMast?.fillColor = COLORTYPE[Int(arc4random_uniform(UInt32(COLORTYPE.count)))]
            }
        }
    }
    
    func createMaster(aMasterColor: UIColor){
        let mMasterColorHeight : CGFloat = 100.0
        var locBox : CGRect = CGRectMake( CGRectGetMidX(self.frame) , mMasterColorHeight/2 , self.frame.size.width*2 , mMasterColorHeight)
        let mMasterColor : SKShapeNode = SKShapeNode(rectOfSize: locBox.size)
        
        mMasterColor.fillColor = aMasterColor
        mMasterColor.name = "MasterColor"
        self.addChild(mMasterColor)
    }
    func createGameContainer(){
        let locBox : CGRect = CGRectMake(0,0,300,300)
        let mGameContainer : SKShapeNode = SKShapeNode(rectOfSize: locBox.size)
        
        mGameContainer.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        mGameContainer.fillColor = UIColor.lightGrayColor()
        
        self.addChild(mGameContainer)
        
        self.scene!.physicsBody = SKPhysicsBody(edgeLoopFromRect: mGameContainer.frame)
    }
    func createLabels(){
        let mScoreLabel = SKLabelNode(fontNamed: "Avenir-Book")
        let mTimerLabel = SKLabelNode(fontNamed: "Avenir-Book")
        
        mScoreLabel.text = "Score: \(mScore)"
        mTimerLabel.text = "Time: \(mTime)"
        
        mScoreLabel.fontSize = 20
        mTimerLabel.fontSize = 20
        
        mScoreLabel.fontColor = UIColor.blackColor()
        mTimerLabel.fontColor = UIColor.blackColor()
        
        mScoreLabel.position.x = mScoreLabel.frame.size.width
        mScoreLabel.position.y = self.frame.size.height - (mScoreLabel.frame.size.height + 100)
        mTimerLabel.position.x = self.frame.size.width - mTimerLabel.frame.size.width
        mTimerLabel.position.y = self.frame.size.height - (mTimerLabel.frame.size.height + 100)
        
        self.addChild(mScoreLabel)
        self.addChild(mTimerLabel)
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({self.updateLabels(mTimerLabel , aScore: mScoreLabel)}),
            SKAction.waitForDuration(0.1)
            ])
        ))

    }
    func createBalls(aNumber: Int){
        for var i = 0; i < aNumber; i++ {
            self.createSingleBall(COLORTYPE[i], aFric: 0, aRest: 1, aDamp: 0, aAngDamp: 0)
        }
        
    }
    func runTimer(){
        if self.mTime > 0{
            self.mTime -= 1
        }else{
            let locMast = self.childNodeWithName("MasterColor") as? SKShapeNode
            let reveal = SKTransition.fadeWithColor(locMast!.fillColor, duration: 1.0)
            let scene = EndGameScene(size:self.size, aScore: mScore)
            self.view?.presentScene(scene, transition:reveal)
        }
    }
    func updateLabels(aTimer: SKLabelNode, aScore: SKLabelNode){
        aTimer.text = "Time: \(mTime)"
        aScore.text = "Score: \(mScore)"
    }
    func createSingleBall(aColorType: UIColor, aFric: CGFloat, aRest: CGFloat, aDamp: CGFloat, aAngDamp: CGFloat){
        let locBall = SKShapeNode(circleOfRadius: 20)
        
        locBall.fillColor = aColorType
        locBall.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        locBall.name = "Ball"
        
        println(locBall.fillColor)
        self.addChild(locBall)

        locBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        locBall.physicsBody?.dynamic = true
        locBall.physicsBody?.friction = aFric
        locBall.physicsBody?.restitution = aRest
        locBall.physicsBody?.linearDamping = aDamp
        locBall.physicsBody?.angularDamping = aAngDamp
        locBall.physicsBody?.applyImpulse(CGVectorMake(random(-10,max:10)*0.5,random(-10,max:10)*0.5))
        locBall.physicsBody?.categoryBitMask = PhysicsCollision.BallCat
        locBall.physicsBody?.contactTestBitMask = PhysicsCollision.BallCat
        
    }
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
}
