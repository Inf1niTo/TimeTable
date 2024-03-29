//
//  NewsView.swift
//  TimeTable
//
//  Created by Антон Плотников on 25.01.2024.
//

import SwiftUI

struct NewsView: View {
    @StateObject var data = Requesting()

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(data.newsData, id: \.title) { newsItem in
                        Button {
                            if let url = URL(string: newsItem.href) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: newsItem.imageUrl)!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100) // Set a default size

                                VStack(alignment: .leading) {
                                    Text(newsItem.title)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .lineLimit(2)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        
                                    Text(newsItem.date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 10)
                            .background(Color.gray.opacity(0.08))
                            .padding(.horizontal, 10)
                            .cornerRadius(30)
                        }
                    }
                }
            }
            .navigationTitle("Новости")
            
            .onAppear {
                data.fetchNews()
            }
            
            .onChange(of: data.newsData) { newNewsData in
            
                print(newNewsData)
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
