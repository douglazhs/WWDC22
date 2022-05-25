//
//  File.swift
//  
//
//  Created by Douglas Henrique de Souza Pereira on 10/04/22.
//

import Foundation
import SwiftUI

struct LastView: View{
    @Binding var showOnboarding: Bool
    
    var body: some View{
        VStack{
            Text("Let's help our planet!")
                .font(.custom(FONT_NAME, size: 38))
                .foregroundColor(Color(FONT_COLOR))
                .padding(.top, 100)
            
            Spacer()
            
            Image(SAD_PLANET)
                .resizable()
                .frame(width: UIScreen.main.bounds.width*0.4,
                       height: UIScreen.main.bounds.height*0.3)
            
            Spacer()
            
            HStack{
                
                NavigationLink {
                    CreditsView()
                } label: {
                    ZStack{
                        Image(CREDITS_BUTTON)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.8)
                    }
                    .padding()
                }
                
                Button {
                    showOnboarding.toggle()
                } label: {
                    ZStack{
                        Image(BUTTON_START)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.8)
                    }
                    .padding()
                }
            }
            .padding(.bottom, 50)
        }
    }
}
