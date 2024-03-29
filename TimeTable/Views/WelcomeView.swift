//
//  WelcomeView.swift
//  Raspisanie_2
//
//  Created by Антон Плотников on 06.01.2024.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Text("Добро пожаловать в приложение \nРасписание ГУУ!")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 25)
                Spacer()
                
                Button {
            //
                } label:{
                    NavigationLink {
                        SelectionGroup(data: Requesting())
                    } label: {
                        Text("Продолжить")
                            .padding()
                            .frame(width: 340, height: 48, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                    }
                
            }
        }
        }

}
#Preview {
    WelcomeView()
}

