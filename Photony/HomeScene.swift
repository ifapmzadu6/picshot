//
//  HomeScene.swift
//  Photony
//
//  Created by 狩宿恵介 on 2015/05/13.
//  Copyright (c) 2015年 KeisukeKarijuku. All rights reserved.
//

import UIKit
import SpriteKit

protocol HomeSceneDelegate: NSObjectProtocol {
    func didSelectTwitter()
    func didSelectFacebook()
    func willSelectInstagram()
    func didSelectInstagram()
    func didSelectAlbumButton()
}

class HomeScene: SKScene {
    
    weak var myDelegate: HomeSceneDelegate?
    
    var titleNode: SKLabelNode?
    var imageNode: SKShapeNode?
    var splashNode: SKShapeNode?
    var arrowNode: SKShapeNode?
    var pointerNode: SKShapeNode?
    var pullToLabelNode: SKLabelNode?
    var releaseToLabelNode: SKLabelNode?
    
    var twitterNode: SKShapeNode?
    var twitterIconNode: SKShapeNode?
    var facebookNode: SKShapeNode?
    var facebookIconNode: SKShapeNode?
    var instagramNode: SKShapeNode?
    var instagramIconNode: SKShapeNode?
    
    var albumImageNode: SKSpriteNode?
    
    var isDragging: Bool = false
    var draggingPosition: CGPoint = CGPointZero
    var bounceTimer: NSTimer?
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        backgroundColor = UIColor.whiteColor()
        
        titleNode = SKLabelNode(text: "picshot")
        if let node = titleNode {
            node.fontName = "Avenir-Roman"
            node.fontSize = 26
            node.fontColor = UIColor(white: 0.6, alpha: 1)
            node.position.x = center.x
            node.position.y = view.bounds.size.height - 70
            addChild(node)
        }
        
        twitterNode = SKShapeNode(circleOfRadius: radius)
        if let node = twitterNode {
            node.fillColor = twitterColor
            node.position = twitterCenter
            node.alpha = 0
            addChild(node)
            
            twitterIconNode = SKShapeNode(circleOfRadius: radius * 0.7)
            if let childnode = twitterIconNode {
                childnode.fillTexture = SKTexture(imageNamed: "TwitterIcon")
                childnode.fillColor = UIColor.whiteColor()
                childnode.lineWidth = 0
                node.addChild(childnode)
            }
            
            node.runAction(SKAction.scaleBy(0, duration: 0), completion: { () -> Void in
                node.alpha = 1
                node.runAction(SKAction.scaleBy(1, duration: 1, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
            })
        }
        
        facebookNode = SKShapeNode(circleOfRadius: radius)
        if let node = facebookNode {
            node.fillColor = facebookColor
            node.position = facebookCenter
            node.alpha = 0
            addChild(node)
            
            facebookIconNode = SKShapeNode(circleOfRadius: radius * 0.7)
            if let childnode = facebookIconNode {
                childnode.fillTexture = SKTexture(imageNamed: "FacebookIcon")
                childnode.fillColor = UIColor.whiteColor()
                childnode.lineWidth = 0
                node.addChild(childnode)
            }
            
            node.runAction(SKAction.scaleBy(0, duration: 0), completion: { () -> Void in
                node.alpha = 1
                node.runAction(SKAction.scaleBy(1, duration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
            })
        }
        
        instagramNode = SKShapeNode(circleOfRadius: radius)
        if let node = instagramNode {
            node.fillColor = instagramColor
            node.position = instagramCenter
            node.alpha = 0
            addChild(node)
            
            instagramIconNode = SKShapeNode(circleOfRadius: radius * 0.7)
            if let childnode = instagramIconNode {
                childnode.fillTexture = SKTexture(imageNamed: "InstagramIcon")
                childnode.fillColor = UIColor.whiteColor()
                childnode.lineWidth = 0
                node.addChild(childnode)
            }
            
            node.runAction(SKAction.scaleBy(0, duration: 0), completion: { () -> Void in
                node.alpha = 1
                node.runAction(SKAction.scaleBy(1, duration: 1, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
            })
        }
        
        
        let path = UIBezierPath.bezierPathWithArrowFromPoint(CGPointMake(0, 30), endPoint: CGPointZero, tailWidth: 15, headWidth: 30, headLength: 15)
        arrowNode = SKShapeNode(path: path.CGPath, centered: true)
        if let node = arrowNode {
            node.fillColor = UIColor(white: 0.9, alpha: 1)
            node.position = center
            node.position.y -= radius + 30
            node.alpha = 0
            addChild(node)
        }
        
        imageNode = SKShapeNode(circleOfRadius: radius)
        if let node = imageNode {
            node.fillColor = UIColor.whiteColor()
            node.position = center
            node.zPosition = 1
            node.alpha = 0
            addChild(node)
            
            node.runAction(SKAction.scaleTo(0, duration: 0))
        }
        
        splashNode = SKShapeNode(circleOfRadius: radius)
        if let node = splashNode {
            node.fillColor = UIColor.clearColor()
            node.strokeColor = UIColor(white: 0.92, alpha: 1)
            node.lineWidth = 3
            node.position = center
            node.zPosition = 0
            node.alpha = 0
            addChild(node)
            
            node.runAction(SKAction.scaleTo(0, duration: 0))
        }
        
        let narrowPath = UIBezierPath.bezierPathWithArrowFromPoint(CGPointMake(0, 50), endPoint: CGPointZero, tailWidth: 15, headWidth: 30, headLength: 15)
        pointerNode = SKShapeNode(path: narrowPath.CGPath, centered: true)
        if let node = pointerNode {
            node.fillColor = UIColor(white: 0.9, alpha: 1)
            node.position = center
            node.alpha = 0
            addChild(node)
            
            node.runAction(SKAction.scaleTo(0, duration: 0))
            node.runAction(SKAction.rotateToAngle(twitterTheta + CGFloat(M_PI_2), duration: 0))
        }
        
        pullToLabelNode = SKLabelNode(text: "Pull Down to Share")
        if let node = pullToLabelNode {
            node.fontName = "Avenir-Book"
            node.fontSize = 20
            node.fontColor = UIColor(white: 0.8, alpha: 1)
            node.position = center
            node.position.y -= radius + 70
            node.alpha = 0
            addChild(node)
        }
        
        let text: String
        if arc4random() % 2 == 0 {
            text = "Let Go"
        }
        else {
            text = "Release to Share"
        }
        releaseToLabelNode = SKLabelNode(text: text)
        if let node = releaseToLabelNode {
            node.fontName = "Avenir-Book"
            node.fontSize = 26
            node.fontColor = UIColor(white: 0.6, alpha: 1)
            node.position.x = center.x
            node.position.y = view.bounds.size.height - 70
            node.alpha = 0
            node.colorBlendFactor = 0
            addChild(node)
        }
        
        albumImageNode = SKSpriteNode(imageNamed: "SearchIcon")
        if let node = albumImageNode {
            node.size = CGSizeMake(44, 44)
            node.position = CGPointMake(view.bounds.size.width-22, 22)
            node.alpha = 0
            addChild(node)
        }
    }
    
    // MARK: -
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            if let touch = touch as? UITouch, node = imageNode {
                let position = touch.locationInNode(self)
                if CGRectContainsPoint(node.frame, position) == true {
                    isDragging = true
                    draggingPosition = position
                    
                    titleNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.2))
                    pointerNode?.runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
                    splashNode?.removeAllActions()
                    splashNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.2))
                }
                
                if nodeAtPoint(position) == albumImageNode {
                    myDelegate?.didSelectAlbumButton()
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            if let touch = touch as? UITouch, view = view where isDragging == true {
                let position = touch.locationInNode(self)
                let radius = sqrt(pow(position.x - draggingPosition.x, 2) + pow(position.y - draggingPosition.y, 2))
                let cosx = (position.x - draggingPosition.x) / radius
                let sinx = (position.y - draggingPosition.y) / radius
                let x = cosx * radius / 1.5
                let y = sinx * radius / 1.5
                imageNode?.runAction(SKAction.moveTo(CGPointMake(center.x + x, center.y + y), duration: 0.05))
                
                if radius < 100 || (position.y - draggingPosition.y) > 0 {
                    twitterNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                    facebookNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                    instagramNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                    pointerNode?.runAction(SKAction.scaleTo(0, duration: 0.2))
                    pointerNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
                    
                    arrowNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                    pullToLabelNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                    releaseToLabelNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
                }
                else {
                    var theta = atan((position.y - draggingPosition.y)/(position.x - draggingPosition.x))
                    if theta < 0 {
                        theta += CGFloat(M_PI)
                    }
                    let diffTwitter = abs(theta - twitterTheta)
                    let diffFacebook = abs(theta - facebookTheta)
                    let diffInstagram = abs(theta - instagramTheta)
                    let minDiff = min(min(diffTwitter, diffFacebook), diffInstagram)
                    if minDiff < CGFloat(M_PI) / 8 {
                        if minDiff == diffTwitter {
                            twitterNode?.runAction(SKAction.scaleTo(1.2, duration: 0.3))
                            facebookNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                            instagramNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                            releaseToLabelNode?.fontColor = twitterColor.colorWithAlphaComponent(0.6)
                            pointerNode?.fillColor = twitterColor.colorWithAlphaComponent(0.4)
                        }
                        else if minDiff == diffFacebook {
                            facebookNode?.runAction(SKAction.scaleTo(1.2, duration: 0.3))
                            twitterNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                            instagramNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                            releaseToLabelNode?.fontColor = facebookColor.colorWithAlphaComponent(0.6)
                            pointerNode?.fillColor = facebookColor.colorWithAlphaComponent(0.4)
                        }
                        else if minDiff == diffInstagram {
                            instagramNode?.runAction(SKAction.scaleTo(1.2, duration: 0.3))
                            twitterNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                            facebookNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                            releaseToLabelNode?.fontColor = instagramColor.colorWithAlphaComponent(0.6)
                            pointerNode?.fillColor = instagramColor.colorWithAlphaComponent(0.4)
                        }
                        
                        arrowNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
                        pullToLabelNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
                        releaseToLabelNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                        pointerNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
                        pointerNode?.runAction(SKAction.scaleTo(1, duration: 0.2))
                        pointerNode?.runAction(SKAction.rotateToAngle(theta+CGFloat(M_PI_2), duration: 0.05))
                    }
                    else {
                        twitterNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                        facebookNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                        instagramNode?.runAction(SKAction.scaleTo(1, duration: 0.3))
                        pointerNode?.runAction(SKAction.scaleTo(0, duration: 0.2))
                        pointerNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.2))
                    }
                }
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            if let touch = touch as? UITouch, view = view where isDragging == true {
                isDragging = false
                
                let position = touch.locationInNode(self)
                let radius = sqrt(pow(position.x - draggingPosition.x, 2) + pow(position.y - draggingPosition.y, 2))
                
                if radius < 100 || (position.y - draggingPosition.y) > 0 {
                    titleNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
                    imageNode?.runAction(SKAction.moveTo(center, duration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
                    arrowNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                    pointerNode?.runAction(SKAction.scaleTo(0, duration: 0.1))
                    pointerNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
                    pullToLabelNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                    releaseToLabelNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
                    let expand = SKAction.group([SKAction.scaleTo(2, duration: 2), SKAction.fadeAlphaTo(0, duration: 2)])
                    let reset = SKAction.group([SKAction.scaleTo(0.5, duration: 0), SKAction.fadeAlphaTo(1, duration: 0)])
                    splashNode?.runAction(SKAction.repeatActionForever(SKAction.sequence([expand, reset, SKAction.waitForDuration(2)])))
                }
                else {
                    var theta = atan((position.y - draggingPosition.y)/(position.x - draggingPosition.x))
                    if theta < 0 {
                        theta += CGFloat(M_PI)
                    }
                    let diffTwitter = abs(theta - twitterTheta)
                    let diffFacebook = abs(theta - facebookTheta)
                    let diffInstagram = abs(theta - instagramTheta)
                    let minDiff = min(min(diffTwitter, diffFacebook), diffInstagram)
                    if minDiff < CGFloat(M_PI) / 8 {
                        pointerNode?.removeAllActions()
                        pointerNode?.runAction(SKAction.scaleTo(0, duration: 0.2))
                        pointerNode?.alpha = 0
                        
                        if let twitterNode = twitterNode, facebookNode = facebookNode, instagramNode = instagramNode {
                            if minDiff == diffTwitter {
                                imageNode?.runAction(SKAction.moveTo(twitterNode.position, duration: 0.18), completion: {
                                    self.imageNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
                                    self.twitterIconNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.05))
                                    twitterNode.zPosition = 100
                                    facebookNode.zPosition = 0
                                    instagramNode.zPosition = 0
                                    twitterNode.runAction(SKAction.scaleTo(20, duration: 0.6), completion: {
                                        self.myDelegate?.didSelectTwitter()
                                    })
                                })
                            }
                            else if minDiff == diffFacebook {
                                imageNode?.runAction(SKAction.moveTo(facebookNode.position, duration: 0.18), completion: {
                                    self.imageNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
                                    self.facebookIconNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.05))
                                    facebookNode.zPosition = 100
                                    twitterNode.zPosition = 0
                                    instagramNode.zPosition = 0
                                    facebookNode.runAction(SKAction.scaleTo(20, duration: 0.6), completion: {
                                        self.myDelegate?.didSelectFacebook()
                                    })
                                })
                            }
                            else if minDiff == diffInstagram {
                                imageNode?.runAction(SKAction.moveTo(instagramNode.position, duration: 0.18), completion: {
                                    self.myDelegate?.willSelectInstagram()
                                    
                                    self.imageNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
                                    self.instagramIconNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.05))
                                    instagramNode.zPosition = 100
                                    twitterNode.zPosition = 0
                                    facebookNode.zPosition = 0
                                    instagramNode.runAction(SKAction.scaleTo(20, duration: 0.6), completion: {
                                        self.myDelegate?.didSelectInstagram()
                                    })
                                })
                            }
                        }
                    }
                    else {
                        titleNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
                        imageNode?.runAction(SKAction.moveTo(center, duration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
                        arrowNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                        pointerNode?.runAction(SKAction.scaleTo(0, duration: 0.1))
                        pointerNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
                        pullToLabelNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
                        releaseToLabelNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
                        let expand = SKAction.group([SKAction.scaleTo(2, duration: 2), SKAction.fadeAlphaTo(0, duration: 2)])
                        let reset = SKAction.group([SKAction.scaleTo(0.5, duration: 0), SKAction.fadeAlphaTo(1, duration: 0)])
                        splashNode?.runAction(SKAction.repeatActionForever(SKAction.sequence([expand, reset, SKAction.waitForDuration(2)])))
                    }
                }
                
            }
        }
    }
    
    func setImage(image: UIImage) {
        imageNode?.fillTexture = SKTexture(image: image)
        imageNode?.alpha = 1
        imageNode?.runAction(SKAction.scaleTo(1, duration: 1, delay: 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
        
        arrowNode?.runAction(SKAction.fadeAlphaTo(1, duration: 1, delay: 2, usingSpringWithDamping: 1, initialSpringVelocity: 0))
        pullToLabelNode?.runAction(SKAction.fadeAlphaTo(1, duration: 1, delay: 2, usingSpringWithDamping: 1, initialSpringVelocity: 0))
        albumImageNode?.runAction(SKAction.fadeAlphaTo(0.2, duration: 1, delay: 2, usingSpringWithDamping: 1, initialSpringVelocity: 0))
        
        let expand = SKAction.group([SKAction.scaleTo(2, duration: 2), SKAction.fadeAlphaTo(0, duration: 2)])
        let reset = SKAction.group([SKAction.scaleTo(0.5, duration: 0), SKAction.fadeAlphaTo(1, duration: 0)])
        splashNode?.runAction(SKAction.repeatActionForever(SKAction.sequence([expand, reset, SKAction.waitForDuration(2)])))
    }
    
    func resetImage() {
        imageNode?.runAction(SKAction.scaleTo(0, duration: 0))
        arrowNode?.alpha = 0
        pullToLabelNode?.alpha = 0
        albumImageNode?.alpha = 0
        splashNode?.removeAllActions()
        splashNode?.alpha = 0
    }
    
    func reset() {
        titleNode?.alpha = 1
        imageNode?.alpha = 1
        imageNode?.position = center
        arrowNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
        pointerNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
        pullToLabelNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
        releaseToLabelNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.1))
        twitterNode?.alpha = 1
        twitterNode?.runAction(SKAction.scaleTo(1, duration: 0.6), completion: {
            self.twitterIconNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.05))
        })
        facebookNode?.alpha = 1
        facebookNode?.runAction(SKAction.scaleTo(1, duration: 0.6), completion: {
            self.facebookIconNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.05))
        })
        instagramNode?.alpha = 1
        instagramNode?.runAction(SKAction.scaleTo(1, duration: 0.6), completion: {
            self.instagramIconNode?.runAction(SKAction.fadeAlphaTo(1, duration: 0.05))
        })
        let expand = SKAction.group([SKAction.scaleTo(2, duration: 2), SKAction.fadeAlphaTo(0, duration: 2)])
        let reset = SKAction.group([SKAction.scaleTo(0.5, duration: 0), SKAction.fadeAlphaTo(1, duration: 0)])
        splashNode?.runAction(SKAction.repeatActionForever(SKAction.sequence([expand, reset, SKAction.waitForDuration(2)])))
    }
    
    
    private var radius: CGFloat {
        if let view = view {
            return view.bounds.size.width / 8
        }
        return 0
    }
    private var center: CGPoint {
        if let view = view {
            return CGPointMake(view.center.x, view.bounds.height*190/568)
        }
        return CGPointZero
    }
    private var twitterCenter: CGPoint {
        if let view = view {
            return CGPointMake(view.center.x, view.bounds.height-view.bounds.height*140/568)
        }
        return CGPointZero
    }
    private var facebookCenter: CGPoint {
        if let view = view {
            return CGPointMake(view.bounds.size.width*3/16, view.bounds.height-view.bounds.height*180/568)
        }
        return CGPointZero
    }
    private var instagramCenter: CGPoint {
        if let view = view {
            return CGPointMake(view.bounds.width-view.bounds.size.width*3/16, view.bounds.height-view.bounds.height*180/568)
        }
        return CGPointZero
    }
    
    private var twitterColor: UIColor {
        return SKColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1)
    }
    private var facebookColor: UIColor {
        return SKColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1)
    }
    private var instagramColor: UIColor {
        return SKColor(red: 63/255.0, green: 114/255.0, blue: 155/255.0, alpha: 1)
    }
    
    private var twitterTheta: CGFloat {
        return atan((twitterCenter.y-center.y)/(twitterCenter.x-center.x))
    }
    private var facebookTheta: CGFloat {
        return atan((facebookCenter.y-center.y)/(facebookCenter.x-center.x)) + CGFloat(M_PI)
    }
    private var instagramTheta: CGFloat {
        return atan((instagramCenter.y-center.y)/(instagramCenter.x-center.x))
    }
}
