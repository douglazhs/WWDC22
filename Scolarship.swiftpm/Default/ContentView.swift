import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @State var showOnboarding: Bool = true
    
    init(){
        //Setup custom fonts
        setupFonts()
    }
    
    ///Add a custom font to the project
    func setupFonts() {
        let cfURL = Bundle.main.url(forResource: "PressStart2P-Regular", withExtension: "ttf")! as CFURL
            CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
    }
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = SCENE_FRAME.size
        scene.scaleMode = .fill
        return scene
    }

    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: SCENE_FRAME.size.width,
                   height: SCENE_FRAME.size.height)
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingViews(showOnboarding: $showOnboarding)
            }
    }
}


