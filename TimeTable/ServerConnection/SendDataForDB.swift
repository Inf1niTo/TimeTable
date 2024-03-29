//
//  SendDataForDB.swift
//  Raspisanie_2
//
//  Created by Антон Плотников on 19.01.2024.
//

import Foundation

struct SendDataForDB{
    
    func authorizeWithCookies() {
        let urlString = "http://5.181.255.253:9000/authorize"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Установка кук в заголовке
        let cookieHeader = "\(UserDefaults.standard.string(forKey: "formattedCookies")!.description);"
        request.addValue(cookieHeader, forHTTPHeaderField: "c")
        print(UserDefaults.standard.string(forKey: "formattedCookies")!.description)
        
        // Отправка запроса
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("Response: \(responseString ?? "Empty response")")
            }
        }
        
        task.resume()
    }
}
