//
//  ContentView.swift
//  Raspisanie_2
//
//  Created by Антон Плотников on 05.01.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    var body: some View {
        ZStack{
            NavigationView{
                if ((UserDefaults.standard.string(forKey: "selectedGroup")?.isEmpty) == nil){
                    WelcomeView()
                }else{
                    
                    TabView(selection: $selectedTab){
                        NewsView(data: Requesting())
                            .tabItem{
                                Image(systemName: "newspaper")
                            }.tag(3)
                        TestView()
                            .tabItem{
                                Image(systemName: "magnifyingglass")
                            }.tag(0)
                        
                        MainView(data: Requesting())
                            .tabItem{
                                Image(systemName: "house")
                            }.tag(1)
                        
                        SettingsView()
                            .tabItem{
                                Image(systemName: "gearshape")
                            }.tag(2)
                        
                    }
                    .onAppear {
                        let tabBarAppearance = UITabBarAppearance()
                        tabBarAppearance.configureWithDefaultBackground()
                        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                    }
                }
            }
            .navigationBarBackButtonHidden()
                
            }
    }
}
#Preview {
    ContentView()
}
