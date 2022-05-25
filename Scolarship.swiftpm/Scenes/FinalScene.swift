//
//  File.swift
//  Scolarship
//
//  Created by Douglas Henrique de Souza Pereira on 05/04/22.
//

import Foundation
import SpriteKit

class FinalScene: SKScene{
    
    //---------- Actual Phrase Index ----------------------
    var actualPhrase: Int = 0
    
    //---------- Final Phrases Array ----------------------
    let phrases = [SKSpriteNode(imageNamed: "Phrase_0"),
                   SKSpriteNode(imageNamed: "Phrase_1"),
                   SKSpriteNode(imageNamed: "Phrase_2")]
    
    //---------- Background Image -------------------------
    var background: SKSpriteNode{
        let background = SKSpriteNode(imageNamed: BACKGROUND_FINAL_SCENE)
        background.position = CGPoint(x: SCENE_FRAME.midX, y: SCENE_FRAME.midY)
        background.size = SCENE_FRAME.size
        return background
    }
    
    //---------- Scene Title ------------------------------
    lazy var title: SKLabelNode = {
        let title = SKLabelNode(fontNamed: FONT_NAME)
        title.fontColor = .white
        title.text = "Congratulations!"
        title.position = CGPoint(x: SCENE_FRAME.width/2, y: SCENE_FRAME.height*0.925)
        return title
    }()
    
    //---------- Congratulations message ------------------
    lazy var message: SKLabelNode = {
        let message = SKLabelNode(fontNamed: FONT_NAME)
        message.text = "Congratulations for finish the game! Here is some notes about improper disposal of garbage!"
        message.fontName = FONT_NAME
        message.fontSize = 22
        message.numberOfLines = 12
        message.fontColor = SKColor(named: FONT_COLOR)
        message.verticalAlignmentMode = .center
        message.preferredMaxLayoutWidth = SCENE_FRAME.width*0.9
        message.lineBreakMode = .byWordWrapping
        message.position = CGPoint(x: SCENE_FRAME.width/2, y: SCENE_FRAME.height*0.75)
        return message
    }()
    
    //---------- Earth Image ------------------------------
    lazy var image: SKSpriteNode = {
        let texture = SKTexture(imageNamed: PLANET)
        let image = SKSpriteNode(texture:  texture)
        image.position = CGPoint(x: SCENE_FRAME.width/2, y:  SCENE_FRAME.height/2)
        image.size = CGSize(width: 300, height: 300)
        image.setScale(0.1)
        return image
    }()
    
    //---------- Next phrase button -----------------------
    lazy var button: SKSpriteNode = {
        let button = SKSpriteNode(texture: SKTexture(imageNamed: NEXT_BUTTON))
        button.name = NEXT_BUTTON
        button.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height*0.2)
        button.setScale(0.25)
        return button
    }()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        addChild(background)
        addChild(title)
        addChild(message)
        addChild(image)
        addChild(button)
        for phrase in phrases {
            phrase.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height*0.5)
        }
        addChild(phrases[actualPhrase])
        actualPhrase += 1
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let element = nodes(at: location).first as? SKSpriteNode {
            if element.name == NEXT_BUTTON && actualPhrase < phrases.count{
                scale(node: element)
                movePhrase(phrases[actualPhrase-1])
                addPhrase(phrases[actualPhrase])
                actualPhrase += 1
            } else if element.name == NEXT_BUTTON && actualPhrase >= phrases.count{
                scale(node: element)
                prepareLastScreen()
                let scaleAction = SKAction.scale(to: 2.5, duration: 1)
                let planetAnimation = SKAction.animate(with: planetTextures(), timePerFrame: 0.3)
                let wait = SKAction.wait(forDuration: 0.3)
                let repeatPlanetAnimation = SKAction.repeatForever(planetAnimation)
                image.run(SKAction.sequence([scaleAction, wait, repeatPlanetAnimation]))
            }
            if element.name == "RetryButton"{
                let scene = GameScene(size: SCENE_FRAME.size)
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
        }
    }
    
    
    /// Generate a texture array
    /// - Returns: Texture Array
    func planetTextures() -> [SKTexture]{
        var textures: [SKTexture] = [SKTexture]()
        for i in 0..<12{
            textures.append(SKTexture(imageNamed: "planet_\(i)"))
        }
        return textures
    }
    
    /// Scale Next Button when clicked
    /// - Parameter node: The touched node
    func scale(node: SKSpriteNode){
        let scale = SKAction.scale(to: 0.35, duration: 0.2)
        let scaleDown = SKAction.scale(to: 0.25, duration: 0.2)
        let sequence = SKAction.sequence([scale, scaleDown])
        node.run(sequence)
    }
    
    /// Move phrase to left and remove It
    /// - Parameter phrase: The current phrase at scene
    func movePhrase(_ phrase: SKSpriteNode){
        let animation = SKAction.fadeOut(withDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([animation, removeAction])
        phrase.run(sequence)
    }
    
    /// After remove the last phrase we add a new one
    /// - Parameter phrase: Phrase at current phrase index
    func addPhrase(_ phrase: SKSpriteNode){
        let moveAction = SKAction.moveTo(x: UIScreen.main.bounds.midX, duration: 0.5)
        phrase.position = CGPoint(x: UIScreen.main.bounds.maxX, y: UIScreen.main.bounds.height*0.5)
        addChild(phrase)
        phrase.run(moveAction)
    }
    
    /// Remove almost of all nodes at scene and create the credits/retry buttons
    func prepareLastScreen(){
        let fadeOut = SKAction.fadeOut(withDuration: 0.6)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let wait = SKAction.wait(forDuration: 0.3)
        title.run(sequence)
        message.run(sequence)
        button.run(sequence)
        phrases[actualPhrase-1].run(sequence)
        
        let retryButton = SKSpriteNode(imageNamed: RETRY_BUTTON)
        retryButton.position = CGPoint(x: SCENE_FRAME.width/2, y: (-frame.minY+retryButton.size.height)+50)
        retryButton.name = "RetryButton"
        retryButton.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown, wait])))
        
        let finalTitle = SKSpriteNode(imageNamed: FINAL_SCENE_TITLE)
        finalTitle.position = CGPoint(x: SCENE_FRAME.midX, y: (frame.maxY-finalTitle.size.height)-50)
        
        addChild(retryButton)
        addChild(finalTitle)
    }
}
