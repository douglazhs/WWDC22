//
//  File.swift
//  Scolarship
//
//  Created by Douglas Henrique de Souza Pereira on 05/04/22.
//

import SpriteKit

class GameScene: SKScene{
    //---------- Columns and lines on board -----------
    var row: Int = 6
    var col: Int = 6
    
    //---------- Move elements on board ---------------
    var touched: Bool = false
    var elementTouched : SKSpriteNode!
    
    //---------- Background ---------------------------
    var floor: SKSpriteNode{
        let background = SKSpriteNode(imageNamed: BACKGROUND)
        background.size = CGSize(width: SCENE_FRAME.width, height: SCENE_FRAME.height)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        return background
    }
    
    //---------- Points -------------------------------
    var points: Int = 0
    var percentage: Int = 0
    var progress: Percentage = .zero
    var totalPoints = 0
    
    //---------- Matriz elements ----------------------
    let matrizElements: [String] = [GLASS_BIN, GLASS, PAPER_BIN, PAPER, PLASTIC_BIN, PLASTIC, METAL_BIN, METAL]
    
    //---------- Hud ----------------------------------
    var hud: HudLayer = HudLayer(screenSize: SCENE_FRAME.size)
    
    //---------- Give Up button -----------------------
    lazy var giveUpButton: SKSpriteNode = {
        let button = SKSpriteNode(imageNamed: GIVE_UP_BUTTON)
        button.position = CGPoint(x: (SCENE_FRAME.maxX-button.frame.width)+75, y: SCENE_FRAME.minY+button.frame.height)
        button.name = "giveUpButton"
        button.alpha = 0
        let message = SKSpriteNode(imageNamed: "No more matches?")
        message.position = CGPoint(x: button.frame.minX, y: button.frame.maxY)
        button.addChild(message)
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1, duration: 0.5)
        let scaleUpDown = SKAction.sequence([scaleUp, scaleDown])
        button.run(SKAction.repeatForever(scaleUpDown))
        return button
    }()
    
    //---------- Phrases ------------------------------
    var actualPhrase: Int = 0
    
    //---------- Random Elements on the board ---------
    var indexes = [Int]()
    
    //---------- Timer --------------------------------
    var levelTimerValue: Int = 4

    override func sceneDidLoad() {
        super.sceneDidLoad()
        createBoard()
        totalPoints = (row*col)/2
        matchTimer()
        addChild(floor)
        addChild(hud)
        addChild(giveUpButton)
    }
    
    /// Create the game board
    func createBoard(){
        let elementSize = (SCENE_FRAME.width-75)/CGFloat(col)
        for i in 0...row - 1{
            for j in 0...col - 1{
                let name = randomBoardElement()
                let element = SKSpriteNode(imageNamed: name)
                element.setScale(0.4)
                element.position = CGPoint(x: CGFloat(j)*elementSize+(elementSize/2)+50,
                                           y: CGFloat(i)*elementSize+(elementSize/2)+40)
                element.name = name
                addChild(element)
            }
        }
    }
    
    /// Randomize elements at the board with no repeats
    /// - Returns: The element that will be added at the board
    func randomBoardElement() -> String{
        if indexes.count == 0 {
            indexes = Array(0..<matrizElements.count)
        }
        let randomIndex = Int(arc4random_uniform(UInt32(indexes.count)))
        let anIndex = indexes.remove(at: randomIndex)
        return matrizElements[anIndex]
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        restartCount()
        
        if let element = nodes(at: location).first as? SKSpriteNode{
            elementTouched = element
            touched = true
            if element.name == "giveUpButton"{
                print("Give Up")
                //TODO: - Present final scene
                showFinalDialogBox()
            }
            if element.name == "OkButton"{
                presentFinalScene()
            }
            if element.name == "CancelButton"{
                self.isPaused = false
                if let node = childNode(withName: "box"){
                    node.removeFromParent()
                }
                if let node = childNode(withName: "dark"){
                    node.removeFromParent()
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        restartCount()
        if let elementMove = nodes(at: location).first as? SKSpriteNode{
            if elementTouched != elementMove && touched && (elementTouched.position.x == elementMove.position.x || elementTouched.position.y == elementMove.position.y){
                if elementTouched.name != "flower" && elementMove.name != "flower"{
                    touched = false
                    moveElement(From: elementTouched, To: elementMove)
                }
            }
        }
    }
    
    /// Change elemets position
    /// - Parameters:
    ///   - originNode: Dragged item
    ///   - destinyNode: For where the origin item were dragged
    func moveElement(From originNode : SKSpriteNode, To destinyNode: SKSpriteNode){
        let pos1 = originNode.position
        let pos2 = destinyNode.position
        let move1 = SKAction.move(to: pos2, duration: 0.1)
        let move2 = SKAction.move(to: pos1, duration: 0.1)
        let check = SKAction.run { [self] in
            self.checkMatch(origin: originNode, destiny: destinyNode)
        }
        let sequence1 = SKAction.sequence([move1, check])
        let sequence2 = SKAction.sequence([move2])
        originNode.run(sequence1)
        destinyNode.run(sequence2)
    }
    
    /// Check if the node 1 matches with node 2
    /// - Parameters:
    ///   - origin: Dragged item
    ///   - destiny: For where the origin item were dragged
    func checkMatch(origin: SKSpriteNode, destiny: SKSpriteNode){
        switch origin.name{
        case Trash.PLASTIC.rawValue:
            if destiny.name == Bin.PLASTIC.rawValue{
                remove(nodes: [origin, destiny])
            }
        case Trash.PAPER.rawValue:
            if destiny.name == Bin.PAPER.rawValue{
                remove(nodes: [origin, destiny])
            }
        case Trash.GLASS.rawValue:
            if destiny.name == Bin.GLASS.rawValue{
                remove(nodes: [origin, destiny])
            }
        case Trash.METAL.rawValue:
            if destiny.name == Bin.METAL.rawValue{
                remove(nodes: [origin, destiny])
            }
        case Bin.PLASTIC.rawValue:
            if destiny.name == Trash.PLASTIC.rawValue{
                remove(nodes: [origin, destiny])
            }
        case Bin.PAPER.rawValue:
            if destiny.name == Trash.PAPER.rawValue{
                remove(nodes: [origin, destiny])
            }
        case Bin.GLASS.rawValue:
            if destiny.name == Trash.GLASS.rawValue{
                remove(nodes: [origin, destiny])
            }
        case Bin.METAL.rawValue:
            if destiny.name == Trash.METAL.rawValue{
                remove(nodes: [origin, destiny])
            }
        default:
            break
        }
    }
    
    /// Add timer action when the user pass 5 seconds or more with no interaction on scene
    func matchTimer(){
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run({
            [unowned self] in

            if self.levelTimerValue > 0{
                self.levelTimerValue -= 1
            } else {
                self.giveUpButton.run(SKAction.fadeAlpha(to: 1, duration: 1))
            }
        })
        let sequence = SKAction.sequence([wait,block])

        run(SKAction.repeatForever(sequence), withKey: "countdown")
    }
    
    /// Restart the count when the user interacts on scenes
    func restartCount(){
        self.levelTimerValue = 4
        self.giveUpButton.run(SKAction.fadeAlpha(to: 0, duration: 0.6))
    }
    
    func showFinalDialogBox(){
        let darkBackground = SKSpriteNode(imageNamed: "Dark")
        darkBackground.name = "dark"
        addChild(darkBackground)
        let box = SKSpriteNode(imageNamed: DIALOG_BOX)
        box.position = CGPoint(x: SCENE_FRAME.midX, y: -SCENE_FRAME.minY)
        box.name = "box"
        let cancelButton = SKSpriteNode(imageNamed: CANCEL_BUTTON)
        cancelButton.position = CGPoint(x: -SCENE_FRAME.midX+cancelButton.frame.width, y: box.frame.minY+cancelButton.frame.height*0.5)
        cancelButton.name = "CancelButton"
        let okButton = SKSpriteNode(imageNamed: OK_BUTTON)
        okButton.position = CGPoint(x: box.frame.midX-cancelButton.frame.width, y: box.frame.minY+cancelButton.frame.height*0.5)
        okButton.name = "OkButton"
        box.addChild(cancelButton)
        box.addChild(okButton)
        let moveUp = SKAction.moveTo(y: SCENE_FRAME.midY+100, duration: 0.2)
        let moveDown = SKAction.moveTo(y: SCENE_FRAME.midY-50, duration: 0.2)
        let moveUp2 = SKAction.moveTo(y: SCENE_FRAME.midY+50, duration: 0.2)
        let moveDown2 = SKAction.moveTo(y: SCENE_FRAME.midY, duration: 0.2)
        addChild(box)
        box.run(SKAction.sequence([moveUp, moveDown, moveUp2, moveDown2]))
    }
    
    /// Remove nodes when 2 items match
    /// - Parameter nodes: Array that contains 2 nodes that matched
    func remove(nodes: [SKSpriteNode]){
        var positions = [CGPoint]()
        for node in nodes {
            positions.append(node.position)
            node.removeFromParent()
        }
        points += 1
        calculatePercentage()
        choosePercentageBar()
        showPhrases()
    }
    
    /// Show phrases when 2 items match
    func showPhrases(){
        let label = SKSpriteNode(texture: SKTexture(imageNamed: "matchPhrase_\(actualPhrase)"))
        label.setScale(0.35)
        label.zPosition = 2
        label.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height*0.8)
        let fadeInAnimation = SKAction.fadeIn(withDuration: 3)
        let fadeOutAnimation = SKAction.fadeOut(withDuration: 1.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeInAnimation, fadeOutAnimation, remove])
        label.run(sequence)
        addChild(label)
        actualPhrase += 1
    }
    
    
    /// Present the last scene
    func presentFinalScene(){
        let finalScene = FinalScene()
        finalScene.size = CGSize(width: SCENE_FRAME.width, height: SCENE_FRAME.height)
        finalScene.scaleMode = .aspectFill
        self.view?.presentScene(finalScene, transition: SKTransition.fade(with: .black, duration: 1))
    }
    
    /// Calculate new percentage after matches
    func calculatePercentage(){
        self.percentage = (100*points)/totalPoints
        self.hud.percentageNumber = percentage
    }
    
    /// Choose the new percentage bar asset
    func choosePercentageBar(){
        switch self.percentage{
        case 0..<10:
            self.progress = .zero
        case 10..<19:
            self.progress = .ten
        case 20..<29:
            self.progress = .twenty
        case 30..<39:
            self.progress = .thirty
        case 40..<49:
            self.progress = .forty
        case 50..<59:
            self.progress = .fifty
        case 60..<69:
            self.progress = .sixty
        case 70..<79:
            self.progress = .seventy
        case 80..<89:
            self.progress = .eighty
        case 90..<99:
            self.progress = .ninety
        case 100:
            self.progress = .hundred
        default:
            break
        }
        
        //Blink animation
        
        self.hud.bar.texture = SKTexture(imageNamed: progress.rawValue)
        let scaleUpAnimation = SKAction.scale(to: 1.1, duration: 0.3)
        let scaleDownAnimation = SKAction.scale(to: 1, duration: 0.3)
        
        let blink = SKAction.animate(with: [SKTexture(imageNamed: "ProgressBar_0"), SKTexture(imageNamed: progress.rawValue)], timePerFrame: 0.5)
        
        let repeatBlink = SKAction.repeatForever(blink)
        
        let sequence = SKAction.sequence([scaleUpAnimation, scaleDownAnimation, repeatBlink])

        self.hud.bar.run(sequence)
    }
    
    /// Add HUD to the Game Screen
    func addHud(){
        // --------- Background -------------
        let hudBackground = SKSpriteNode(imageNamed: HUD_BACKGROUND)
        hudBackground.size = CGSize(width: self.frame.width, height: self.frame.height*0.3)
        hudBackground.position = CGPoint(x: self.frame.midX+22.5, y: self.frame.height*0.875)
        hudBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(hudBackground)
        // --------- Progressa bar ----------
        let bar = SKSpriteNode(imageNamed: PROGRESS_BAR)
        bar.size = CGSize(width: 412, height: 400)
        bar.position = CGPoint(x: self.frame.midX+10, y: self.frame.height*0.875)
        addChild(bar)
    }
}
