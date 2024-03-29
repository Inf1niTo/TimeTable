//
//  FetchData.swift
//  Raspisanie_2
//
//  Created by Антон Плотников on 15.01.2024.
//

import Foundation
class Requesting: ObservableObject{
@Published var dataBase:[String: [Event]] = [:]
    var list:[String] = []
    var group:String = ""
    var selectedGroup = ""
@Published var newsData:[NewsItem] = []
    
    struct NewsResponse: Codable {
        let news: [NewsItem]
    }
    
    func fetchDataFromAPI(urlString: String, completion: @escaping ([String: [Event]]?) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        if let date = dateFormatter.date(from: dateString) {
                            return date
                        } else {
                            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string does not match format expected by formatter.")
                        }
                    }

                    let eventsData = try decoder.decode([String: [Event]].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.dataBase = eventsData
                        
                        // Сохранение в UserDefaults также в основной очереди
//                        UserDefaults.standard.set(try? PropertyListEncoder().encode(eventsData), forKey: "cachedData")
//                        debugPrint("nqcnwinvwjrbv")
                    }
                    completion(eventsData)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    func getClasses(group:String) {
        print("\(group)")
        // Пример использования функции
        let apiUrl = "http://5.181.255.253:9000/classes?g=\(group)"
        fetchDataFromAPI(urlString: apiUrl) { (eventsData) in
            if let eventsData = eventsData {
                // Теперь у вас есть декодированные данные для дальнейшей обработки
                print(eventsData)
            } else {
                print("Failed to fetch data from API in main")
            }
            
        }
    }
    
    func search() {
        guard let url = URL(string: "http://5.181.255.253:9000/groups") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode([String].self, from: data)
                DispatchQueue.main.async {
                    self.list = results
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }
    
    func fetchNews() {
        guard let url = URL(string: "http://5.181.255.253:9000/news") else {
            print("error 1")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error 2")
                return
            }

            do {
                let decoder = JSONDecoder()
                let newsResponse = try decoder.decode([NewsItem].self, from: data)
                self.newsData = newsResponse
                print("no error")
            } catch {
                print("error 4")
            }
        }

        task.resume()
    }
}

