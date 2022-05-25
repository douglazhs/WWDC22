//
//  File.swift
//  
//
//  Created by Douglas Henrique de Souza Pereira on 10/04/22.
//

import Foundation
import SwiftUI

struct InitialView: View{
    var body: some View{
        VStack{
            Text("Throw your garbage away!")
                .font(.custom(FONT_NAME, size: 38))
                .foregroundColor(Color(FONT_COLOR))
                .padding(.top, 100)
            
            Spacer()
            
            Text("The world is suffering from the current annual waste production as it is reaching alarming levels. Therefore, we wanted to ask for your help in correctly disposing of waste.")
                .padding(.horizontal, 50)
                .padding(.top, 25)
                .font(.custom(FONT_NAME, size: 22))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Image(SAD_PLANET)
                .resizable()
                .frame(width: UIScreen.main.bounds.width*0.4,
                       height: UIScreen.main.bounds.height*0.3)
                .padding(.bottom, 200)
        }
    }
}
