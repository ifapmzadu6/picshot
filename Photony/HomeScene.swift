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
    func didSelectCameraButton()
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
    
    var cameraNode: SKSpriteNode?
    var albumImageNode: SKSpriteNode?
    
    var isDragging: Bool = false
    var draggingPosition: CGPoint = .zero
    var bounceTimer: Timer?
    
    
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        backgroundColor = UIColor.white
        
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
                childnode.fillColor = UIColor.white
                childnode.lineWidth = 0
                node.addChild(childnode)
            }
            
            node.run(SKAction.scale(by: 0, duration: 0)) { () -> Void in
                node.alpha = 1
                node.run(SKAction.scale(by: 1, duration: 1, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
            }
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
                childnode.fillColor = UIColor.white
                childnode.lineWidth = 0
                node.addChild(childnode)
            }
            
            node.run(SKAction.scale(by: 0, duration: 0)) { () -> Void in
                node.alpha = 1
                node.run(SKAction.scale(by: 1, duration: 1, delay: 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
            }
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
                childnode.fillColor = UIColor.white
                childnode.lineWidth = 0
                node.addChild(childnode)
            }
            
            node.run(SKAction.scale(by: 0, duration: 0)) { () -> Void in
                node.alpha = 1
                node.run(SKAction.scale(by: 1, duration: 1, delay: 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
            }
        }
        
        
        let path = UIBezierPath.bezierPathWithArrowFromPoint(startPoint: CGPoint(x: 0, y: 30), endPoint: .zero, tailWidth: 15, headWidth: 30, headLength: 15)
        arrowNode = SKShapeNode(path: path.cgPath, centered: true)
        if let node = arrowNode {
            node.fillColor = UIColor(white: 0.9, alpha: 1)
            node.position = center
            node.position.y -= centerRadius + 30
            node.zPosition = 2
            node.alpha = 0
            addChild(node)
        }
        
        imageNode = SKShapeNode(circleOfRadius: centerRadius)
        if let node = imageNode {
            node.fillColor = UIColor.white
            node.position = center
            node.zPosition = 10
            node.alpha = 0
            addChild(node)
            
            node.run(SKAction.scale(to: 0, duration: 0))
        }
        
        splashNode = SKShapeNode(circleOfRadius: centerRadius*2)
        if let node = splashNode {
            node.fillColor = twitterColor.withAlphaComponent(0.1)
            node.strokeColor = twitterColor.withAlphaComponent(0.7)
            node.lineWidth = 2
            node.position = center
            node.zPosition = 1
            node.alpha = 0
            addChild(node)
            
            node.run(SKAction.scale(to: 0, duration: 0))
        }
        
        let narrowPath = UIBezierPath.bezierPathWithArrowFromPoint(startPoint: CGPoint(x: 0, y: 50), endPoint: .zero, tailWidth: 15, headWidth: 30, headLength: 15)
        pointerNode = SKShapeNode(path: narrowPath.cgPath, centered: true)
        if let node = pointerNode {
            node.fillColor = UIColor(white: 0.9, alpha: 1)
            node.position = center
            node.alpha = 0
            addChild(node)
            
            node.run(SKAction.scale(to: 0, duration: 0))
            node.run(SKAction.rotate(toAngle: twitterTheta + CGFloat(M_PI_2), duration: 0))
        }
        
        pullToLabelNode = SKLabelNode(text: "Pull Down to Share")
        if let node = pullToLabelNode {
            node.fontName = "Avenir-Book"
            node.fontSize = 20
            node.fontColor = UIColor(white: 0.8, alpha: 1)
            node.position = center
            node.position.y -= centerRadius + 70
            node.zPosition = 2
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
        
        cameraNode = SKSpriteNode(imageNamed: "CameraIcon")
        if let node = cameraNode {
            node.size = CGSize(width: 44, height: 44)
            node.position = CGPoint(x: 22, y: 21)
            node.alpha = 0
            addChild(node)
        }
        
        albumImageNode = SKSpriteNode(imageNamed: "SearchIcon")
        if let node = albumImageNode {
            node.size = CGSize(width: 44, height: 44)
            node.position = CGPoint(x: view.bounds.size.width-22, y: 22)
            node.alpha = 0
            addChild(node)
        }
    }
    
    // MARK: -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            if atPoint(position) == imageNode {
                isDragging = true
                draggingPosition = position
                
                imageNode?.removeAllActions()
                let scale = radius / centerRadius
                imageNode?.run(SKAction.scale(to: scale, duration: 0.1))
                titleNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                pointerNode?.run(SKAction.fadeAlpha(to: 0.2, duration: 0.2))
                splashNode?.removeAllActions()
                splashNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                cameraNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                albumImageNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
            }
            if atPoint(position) == cameraNode {
                myDelegate?.didSelectCameraButton()
            }
            if atPoint(position) == albumImageNode {
                myDelegate?.didSelectAlbumButton()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if isDragging == true {
                let position = touch.location(in: self)
                let radius = sqrt(pow(position.x - draggingPosition.x, 2) + pow(position.y - draggingPosition.y, 2))
                if (position.x - draggingPosition.x) != 0 && (position.y - draggingPosition.y) != 0 {
                    let cosx = (position.x - draggingPosition.x) / radius
                    let sinx = (position.y - draggingPosition.y) / radius
                    let x = cosx * radius / 1.5
                    let y = sinx * radius / 1.5
                    imageNode?.run(SKAction.move(to: CGPoint(x: center.x + x, y: center.y + y), duration: 0.05))
                }
                
                if radius < 100 || (position.y - draggingPosition.y) > 0 {
                    twitterNode?.run(SKAction.scale(to: 1, duration: 0.3))
                    facebookNode?.run(SKAction.scale(to: 1, duration: 0.3))
                    instagramNode?.run(SKAction.scale(to: 1, duration: 0.3))
                    pointerNode?.run(SKAction.scale(to: 0, duration: 0.2))
                    pointerNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                    
                    arrowNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
                    pullToLabelNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
                    releaseToLabelNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
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
                            twitterNode?.run(SKAction.scale(to: 1.2, duration: 0.3))
                            facebookNode?.run(SKAction.scale(to: 1, duration: 0.3))
                            instagramNode?.run(SKAction.scale(to: 1, duration: 0.3))
                            releaseToLabelNode?.fontColor = twitterColor.withAlphaComponent(0.6)
                            pointerNode?.fillColor = twitterColor.withAlphaComponent(0.4)
                        }
                        else if minDiff == diffFacebook {
                            facebookNode?.run(SKAction.scale(to: 1.2, duration: 0.3))
                            twitterNode?.run(SKAction.scale(to: 1, duration: 0.3))
                            instagramNode?.run(SKAction.scale(to: 1, duration: 0.3))
                            releaseToLabelNode?.fontColor = facebookColor.withAlphaComponent(0.6)
                            pointerNode?.fillColor = facebookColor.withAlphaComponent(0.4)
                        }
                        else if minDiff == diffInstagram {
                            instagramNode?.run(SKAction.scale(to: 1.2, duration: 0.3))
                            twitterNode?.run(SKAction.scale(to: 1, duration: 0.3))
                            facebookNode?.run(SKAction.scale(to: 1, duration: 0.3))
                            releaseToLabelNode?.fontColor = instagramColor.withAlphaComponent(0.6)
                            pointerNode?.fillColor = instagramColor.withAlphaComponent(0.4)
                        }
                        
                        arrowNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                        pullToLabelNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                        releaseToLabelNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
                        pointerNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                        pointerNode?.run(SKAction.scale(to: 1, duration: 0.2))
                        pointerNode?.run(SKAction.rotate(toAngle: theta+CGFloat(M_PI_2), duration: 0.05))
                    }
                    else {
                        twitterNode?.run(SKAction.scale(to: 1, duration: 0.3))
                        facebookNode?.run(SKAction.scale(to: 1, duration: 0.3))
                        instagramNode?.run(SKAction.scale(to: 1, duration: 0.3))
                        pointerNode?.run(SKAction.scale(to: 0, duration: 0.2))
                        pointerNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                    }
                }
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if isDragging == true {
                isDragging = false
                
                let position = touch.location(in: self)
                let radius = sqrt(pow(position.x - draggingPosition.x, 2) + pow(position.y - draggingPosition.y, 2))
                
                if radius < 100 || (position.y - draggingPosition.y) > 0 {
                    titleNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                    imageNode?.run(SKAction.scale(to: 1, duration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8))
                    imageNode?.run(SKAction.move(to: center, duration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
                    arrowNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
                    pointerNode?.run(SKAction.scale(to: 0, duration: 0.1))
                    pointerNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                    pullToLabelNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
                    releaseToLabelNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                    cameraNode?.run(SKAction.fadeAlpha(to: 0.2, duration: 0.1))
                    albumImageNode?.run(SKAction.fadeAlpha(to: 0.2, duration: 0.1))
                    animateSplashNode()
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
                        pointerNode?.run(SKAction.scale(to: 0, duration: 0.2))
                        pointerNode?.alpha = 0
                        
                        if let twitterNode = twitterNode, let facebookNode = facebookNode, let instagramNode = instagramNode {
                            if minDiff == diffTwitter {
                                imageNode?.run(SKAction.move(to: twitterNode.position, duration: 0.18), completion: {
                                    self.imageNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.3))
                                    self.twitterIconNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.05))
                                    twitterNode.zPosition = 100
                                    facebookNode.zPosition = 0
                                    instagramNode.zPosition = 0
                                    twitterNode.run(SKAction.scale(to: 20, duration: 0.6), completion: {
                                        self.myDelegate?.didSelectTwitter()
                                    })
                                })
                            }
                            else if minDiff == diffFacebook {
                                imageNode?.run(SKAction.move(to: facebookNode.position, duration: 0.18), completion: {
                                    self.imageNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.3))
                                    self.facebookIconNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.05))
                                    facebookNode.zPosition = 100
                                    twitterNode.zPosition = 0
                                    instagramNode.zPosition = 0
                                    facebookNode.run(SKAction.scale(to: 20, duration: 0.6), completion: {
                                        self.myDelegate?.didSelectFacebook()
                                    })
                                })
                            }
                            else if minDiff == diffInstagram {
                                imageNode?.run(SKAction.move(to: instagramNode.position, duration: 0.18), completion: {
                                    self.myDelegate?.willSelectInstagram()
                                    
                                    self.imageNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.3))
                                    self.instagramIconNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.05))
                                    instagramNode.zPosition = 100
                                    twitterNode.zPosition = 0
                                    facebookNode.zPosition = 0
                                    instagramNode.run(SKAction.scale(to: 20, duration: 0.6), completion: {
                                        self.myDelegate?.didSelectInstagram()
                                    })
                                })
                            }
                        }
                    }
                    else {
                        titleNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                        imageNode?.run(SKAction.scale(to: 1, duration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5))
                        imageNode?.run(SKAction.move(to: center, duration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
                        arrowNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
                        pointerNode?.run(SKAction.scale(to: 0, duration: 0.1))
                        pointerNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                        pullToLabelNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
                        releaseToLabelNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
                        animateSplashNode()
                    }
                }
                
            }
        }
    }
    
    func setImage(image: UIImage) {
        imageNode?.fillTexture = SKTexture(image: image)
        imageNode?.alpha = 1
        imageNode?.run(SKAction.scale(to: 1, duration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0))
        
        arrowNode?.run(SKAction.fadeAlpha(to: 1, duration: 1, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 0))
        pullToLabelNode?.run(SKAction.fadeAlpha(to: 1, duration: 1, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 0))
        cameraNode?.run(SKAction.fadeAlpha(to: 0.2, duration: 1, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 0))
        albumImageNode?.run(SKAction.fadeAlpha(to: 0.2, duration: 1, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 0))
        animateSplashNode()
    }
    
    func resetImage() {
        imageNode?.run(SKAction.scale(to: 0, duration: 0))
        arrowNode?.alpha = 0
        pullToLabelNode?.alpha = 0
        cameraNode?.alpha = 0
        albumImageNode?.alpha = 0
        splashNode?.removeAllActions()
        splashNode?.alpha = 0
    }
    
    func reset() {
        titleNode?.alpha = 1
        imageNode?.alpha = 1
        imageNode?.run(SKAction.scale(to: 1, duration: 0))
        imageNode?.position = center
        arrowNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
        pointerNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
        pullToLabelNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
        releaseToLabelNode?.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
        twitterNode?.alpha = 1
        twitterNode?.run(SKAction.scale(to: 1, duration: 0.6), completion: {
            self.twitterIconNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.05))
        })
        facebookNode?.alpha = 1
        facebookNode?.run(SKAction.scale(to: 1, duration: 0.6), completion: {
            self.facebookIconNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.05))
        })
        instagramNode?.alpha = 1
        instagramNode?.run(SKAction.scale(to: 1, duration: 0.6), completion: {
            self.instagramIconNode?.run(SKAction.fadeAlpha(to: 1, duration: 0.05))
        })
        cameraNode?.alpha = 0.2
        albumImageNode?.alpha = 0.2
        animateSplashNode()
    }
    
    
    private func animateSplashNode() {
        let expand = SKAction.group([SKAction.scale(to: 1.5, duration: 3), SKAction.fadeAlpha(to: 0, duration: 3)])
        expand.timingMode = .easeOut
        let reset = SKAction.group([SKAction.scale(to: 0.45, duration: 0), SKAction.fadeAlpha(to: 1, duration: 0)])
        splashNode?.run(SKAction.repeatForever(SKAction.sequence([expand, reset, SKAction.wait(forDuration: 2)])))
    }
    
    private var radius: CGFloat {
        if let view = view {
            return view.bounds.size.width / 8
        }
        return 0
    }
    private var centerRadius: CGFloat {
        if let view = view {
            return view.bounds.size.width / 7.5
        }
        return 0
    }
    private var center: CGPoint {
        if let view = view {
            return CGPoint(x: view.center.x, y: view.bounds.height*190/568)
        }
        return .zero
    }
    private var twitterCenter: CGPoint {
        if let view = view {
            return CGPoint(x: view.center.x, y: view.bounds.height-view.bounds.height*140/568)
        }
        return .zero
    }
    private var facebookCenter: CGPoint {
        if let view = view {
            return CGPoint(x: view.bounds.size.width*3/16, y: view.bounds.height-view.bounds.height*180/568)
        }
        return .zero
    }
    private var instagramCenter: CGPoint {
        if let view = view {
            return CGPoint(x: view.bounds.width-view.bounds.size.width*3/16, y: view.bounds.height-view.bounds.height*180/568)
        }
        return .zero
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
