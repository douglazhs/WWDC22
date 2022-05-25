//
//  File.swift
//  
//
//  Created by Douglas Henrique de Souza Pereira on 11/04/22.
//

import Foundation
import SwiftUI

/// Credits scene 
struct CreditsView: View{
    var body: some View{
        ZStack{
            VStack{
                
                Image(FONT_CREDIT)
                
                Spacer()
            }
        }.background(
            Image(BACKGROUND_FINAL_SCENE)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}
