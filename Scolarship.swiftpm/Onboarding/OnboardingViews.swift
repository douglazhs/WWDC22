//
//  File.swift
//  
//
//  Created by Douglas Henrique de Souza Pereira on 10/04/22.
//

import Foundation
import SwiftUI

struct OnboardingViews: View{
    @Binding var showOnboarding: Bool
    
    var body: some View{
        NavigationView{
            TabView {
                
                InitialView()
                    .background(
                        Image(BACKGROUND_FINAL_SCENE)
                            .resizable()
                            .ignoresSafeArea()
                            .frame(width: SCENE_FRAME.width, height: SCENE_FRAME.height)
                    )
                
                InstructionView(title: "Plastic",
                                trash: PLASTIC,
                                bin: PLASTIC_BIN,
                                text: "Plastic is discarded in the red-colored bin.")
                .background(
                    Image(BACKGROUND_FINAL_SCENE)
                        .resizable()
                        .ignoresSafeArea()
                        .frame(width: SCENE_FRAME.width, height: SCENE_FRAME.height)
                )
                
                
                
                InstructionView(title: "Glass",
                                trash: GLASS,
                                bin: GLASS_BIN,
                                text: "Glass is discarded in the green-colored bin.")
                .background(
                    Image(BACKGROUND_FINAL_SCENE)
                        .resizable()
                        .ignoresSafeArea()
                        .frame(width: SCENE_FRAME.width, height: SCENE_FRAME.height)
                )
                
                InstructionView(title: "Paper", trash: PAPER,
                                bin: PAPER_BIN,
                                text: "Paper is discarded in the blue-colored bin.")
                .background(
                    Image(BACKGROUND_FINAL_SCENE)
                        .resizable()
                        .ignoresSafeArea()
                        .frame(width: SCENE_FRAME.width, height: SCENE_FRAME.height)
                )
                
                InstructionView(title: "Metal",
                                trash: METAL,
                                bin: METAL_BIN,
                                text: "Metal is discarded in the yellow-colored bin.")
                
                LastView(showOnboarding: $showOnboarding)
            }
            .background(
                Image(BACKGROUND_FINAL_SCENE)
                    .resizable()
                    .ignoresSafeArea()
                    .frame(width: SCENE_FRAME.width, height: SCENE_FRAME.height)
            )
            .tabViewStyle(PageTabViewStyle())
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
