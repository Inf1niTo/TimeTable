//
//  SettingsView.swift
//  Raspisanie_2
//
//  Created by Антон Плотников on 06.01.2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var showWebView = false
    private let urlString: String = "https://my.guu.ru"
    var body: some View {
        VStack{
            Button {
                UserDefaults.standard.removeObject(forKey: "formattedCookies")
            } label:{
                NavigationLink{
                    SelectionGroup(data: Requesting())
                    
                } label: {
                    Text("Выбрать другую группу")
                        .padding()
                        .frame(width: 340, height: 48, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .navigationBarBackButtonHidden()
                
            }
            
            Button {
                showWebView = true
                    
                } label: {
                    Text("Отрыть сайт ГУУ")
                        .padding()
                        .frame(width: 340, height: 48, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .navigationBarBackButtonHidden()

        }
        .sheet(isPresented: $showWebView) {
            WebView(url: URL(string: urlString)!)
        }
        //.ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
}

