//
//  File.swift
//  
//
//  Created by Douglas Henrique de Souza Pereira on 10/04/22.
//

import Foundation
import SwiftUI

struct InstructionView: View{
    var title: String
    var trash: String
    var bin: String
    var text: String
    
    var animation: Animation {
        Animation.easeInOut
        .repeatForever(autoreverses: false)
    }
    
    var body: some View{
        VStack{
            
            Text(title)
                .font(.custom(FONT_NAME, size: 38))
                .foregroundColor(Color(FONT_COLOR))
                .padding(.top, 100)
            
            Spacer()
            
            HStack{
                
                Image(trash)
                    .resizable()
                    .scaleEffect(0.3)
                    .aspectRatio(contentMode: .fit)
                
                Image(NEXT_BUTTON)
                    .resizable()
                    .scaleEffect(0.5)
                    .aspectRatio(contentMode: .fit)
                
                Image(bin)
                    .resizable()
                    .scaleEffect(0.4)
                    .aspectRatio(contentMode: .fit)
            }
            
            Spacer()
            
            Text(text)
                .padding(.bottom, 175)
                .font(.custom(FONT_NAME, size: 22))
                .foregroundColor(.white)
        }
    }
}
