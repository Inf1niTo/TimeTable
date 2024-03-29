//
//  SelectionGroup.swift
//  Raspisanie_2
//
//  Created by Антон Плотников on 17.01.2024.
//

import SwiftUI
import WebKit

struct SelectionGroup: View {
    @State var searchQuery: String = ""
    @State var groups: [String] = []
    @State private var showWebView = false
    private let urlString: String = "https://my.guu.ru"
    @State private var selectedGroup: String = ""
    var data = Requesting()
    var sendData = SendDataForDB()
    @State var isActiveLink = false
    
    
    var body: some View {
        //NavigationView{
            VStack {
                TextField("Search", text: $searchQuery)
                    .padding(.top, 14)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchQuery) { newSearchQuery in
                        // Фильтрация массива groups по введенному значению
                        groups = data.list.filter { group in
                            // Используйте case-insensitive сравнение для поиска
                            return group.localizedCaseInsensitiveContains(newSearchQuery)
                        }
                    }
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(groups, id: \.self) { group in
                            Button(action: {
                                UserDefaults.standard.removeObject(forKey: "selectedGroup")
                                // Обработчик нажатия кнопки, выводит название группы
                                print("Selected group: \(group)")
                                selectedGroup = group
                                print("Selected group: \(selectedGroup)")
                                
                                
                            }) {
                                Text(group)
                                    .padding()
                                    .frame(width: 360)
                                    .background(selectedGroup == group ? Color.blue : Color.gray.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Button {
                    //UserDefaults.standard.removeObject(forKey: "formattedCookies")
                    UserDefaults.standard.setValue(selectedGroup, forKey: "selectedGroup")
                    isActiveLink = true
                } label:{
                    Text("Продолжить")
                        .padding()
                        .frame(width: 340, height: 48, alignment: .center)
                        .background( selectedGroup.isEmpty ? Color.gray.opacity(0.4) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .background(NavigationLink("", destination: ContentView(), isActive: $isActiveLink))
                
                
                
                Button {
                    //UserDefaults.standard.removeObject(forKey: "formattedCookies")
                    showWebView = true
                } label:{
                    Text("Нет моей группы")
                        .font(.system(size: 15))
                        .padding(.vertical, 10)
                        .foregroundColor(.blue)
                }
                
            }
            .sheet(isPresented: $showWebView) {
                WebView(url: URL(string: urlString)!)
                    .onChange(of: UserDefaults.standard.string(forKey: "formattedCookies")) {
                        sendData.authorizeWithCookies()
                        print("Data sending")
                        data.search()
                        
                    }
            }
           
            
        //}
        .navigationBarBackButtonHidden()
        .onAppear() {
            // Инициализация начального списка при загрузке
            data.search()
        }

    }
    
}
struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, nil)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Fetch cookies from WKHTTPCookieStore
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                let formattedCookies = cookies.map { "\($0.name)=\($0.value)" }.joined(separator: "; ")
                var newCookies = shortenCookies(formattedCookies)
                print("Formatted Cookies:\(newCookies)")
                UserDefaults.standard.set(newCookies, forKey: "formattedCookies")
                if newCookies.isEmpty{
                    //
                }else{
                    SendDataForDB().authorizeWithCookies()
                    print("Data sending")
                }
            }

        }
    }
}

func shortenCookies(_ formattedCookies: String) -> String {
    var shortenedCookies = ""

    // Разделяем строку по точке с запятой (;) для получения массива куки
    let cookiesArray = formattedCookies.components(separatedBy: ";")

    // Фильтруем только интересующие нас куки
    let interestingCookies = cookiesArray.filter { cookie in
        return cookie.contains("PHPSESSID") || cookie.contains("_csrf") || cookie.contains("modal_mess")
    }

    // Объединяем интересующие нас куки в одну строку
    shortenedCookies = interestingCookies.joined(separator: "; ")

    return shortenedCookies
}

#Preview {
    SelectionGroup(data: Requesting())
}
