//
//  File.swift
//  Scolarship
//
//  Created by Douglas Henrique de Souza Pereira on 05/04/22.
//

import Foundation
import SpriteKit

open class HudLayer: SKNode{
    var percentageNumber: Int = 0
    var percentage: SKLabelNode = SKLabelNode(fontNamed: FONT_NAME)
    var backgound: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: HUD_BACKGROUND))
    var bar: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: PROGRESS_BAR))
    
    init(screenSize: CGSize){
        super.init()
        // --------- Background -------------
        backgound.size = CGSize(width: screenSize.width, height: screenSize.height*0.3)
        backgound.position = CGPoint(x: (screenSize.width/2), y: screenSize.height*0.85)
        backgound.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(backgound)
        // --------- Progressa bar ----------
        bar.size = CGSize(width: SCENE_FRAME.width*0.5, height: 80)
        bar.position = CGPoint(x: (screenSize.width/2), y: screenSize.height*0.85)
        addChild(bar)
        // --------- Percentage -------------
//        percentage.fontColor = SKColor(red: 0.98, green: 0.773, blue: 0.549, alpha: 1)
//        percentage.text = "\(percentageNumber)%"
//        percentage.fontSize = 48
//        percentage.position = CGPoint(x: bar.frame.maxX+40, y: screenSize.height*0.835)
//        addChild(percentage)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
