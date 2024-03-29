//
//  TestView.swift
//  TimeTable
//
//  Created by Антон Плотников on 19.01.2024.
//

import SwiftUI

struct TestView: View {
    @State private var searchQuery = ""
    @State private var basicList: [String: [Event]] = [:]
    var data = Requesting()

    var body: some View {
        VStack {
            TextField("Search", text: $searchQuery)
                .padding(.top, 14)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchQuery) { newSearchQuery in
                    // Фильтрация словаря basicList по введенному значению
                    basicList = data.dataBase.reduce(into: [:]) { result, entry in
                        let filteredEvents = entry.value.filter { event in
                            let eventInfo = "\(event.title) \(event.description.building) \(event.description.classroom) \(event.description.event) \(event.description.professor) \(event.description.department)"
                            // Используйте case-insensitive сравнение для поиска
                            return eventInfo.localizedCaseInsensitiveContains(newSearchQuery)
                        }
                        if !filteredEvents.isEmpty {
                            result[entry.key] = filteredEvents
                        }
                    }
                    print("Filtered basicList: \(basicList)")
                }
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(basicList.keys.sorted(), id: \.self) { groupName in
                        if let events = basicList[groupName] {
                            ForEach(events, id: \.id) { event in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(event.title)")
                                        .frame(width: 320, alignment: .leading)
                                        .font(.headline)
                                    Text("\(Image(systemName: "clock")) \(formatTime(from: event.start)) - \(formatTime(from: event.end))")
                                        .font(.subheadline)
                                    Text("\(event.description.classroom)")
                                        .font(.subheadline)
                                    Text("\(event.description.event)")
                                        .font(.subheadline)
                                    Text("\(event.description.professor)")
                                        .font(.subheadline)
                                    Text("\(formatDate(from: event.start))")
                                        //.font(.subheadline)
                                    
                                }
                                .padding(20)
                                .background(backgroundForValue(                            event.description.event))
                                .cornerRadius(16)
                            }
                        }
                        
                        Spacer()
                    }

                    }
                }

                }                    
                .onAppear(){
                    data.getClasses(group: UserDefaults.standard.string(forKey: "selectedGroup") ?? "")
            }
        }
    }
func backgroundForValue(_ value: String) -> Color {
    switch value {
    case "Лабораторная работа":
        return Color.blue.opacity(0.18)
    case "Практическое занятие":
        return Color.blue.opacity(0.18)
    case "Лекция":
        return Color.yellow.opacity(0.18)
    case "Экзамен":
        return Color.red.opacity(0.18)
    case "Зачет":
        return Color.green.opacity(0.18)
    default:
        return Color.gray.opacity(0.18)
    }
}

func formatTime(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

func formatDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU") 
    dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
    
    let formattedString = dateFormatter.string(from: date).capitalized
    return formattedString
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

