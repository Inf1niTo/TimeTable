//
//  MainView.swift
//  Raspisanie_2
//
//  Created by Антон Плотников on 06.01.2024.
//

import SwiftUI
import SwiftUIPager
import MarqueeText

struct MainView: View {
    @StateObject var page: Page = .first()
    @State private var selectedDate: Date = Date()
    @ObservedObject var data: Requesting
    @State private var showDetails = false
    
    
    @State private var selectedEvent: Event?
    
    @State var currentTitle = ""
    @State var currentStart = Date()
    @State var currentEnd = Date()
    @State var currentBuilding = ""
    @State var currentClassroom = ""
    @State var currentEvent = ""
    @State var currentProfessor = ""
    @State var currentDepartment = ""
    @State var currentColor = ""
    @State var dayWeek = ""
    @State var selectedDayOfWeek = Date()

    var body: some View {
        VStack {
            HStack{
                MarqueeText(
                text: "\(UserDefaults.standard.string(forKey: "selectedGroup") ?? "")",
                font: UIFont.preferredFont(forTextStyle: .subheadline),
                leftFade: 0,
                rightFade: 0,
                startDelay: 1
                )
                    .padding()
                
                DatePicker("", selection: $selectedDayOfWeek, displayedComponents: .date)
                    .padding()
                    .environment(\.locale, Locale(identifier: "ru_RU"))
              
            }
            Pager(page: page,
                  data: Array(data.dataBase.keys.sorted()),
                  id: \.self) { date in
                if let events = data.dataBase[date] {
                    if events.isEmpty {
                        ScrollView{
                            HStack{
                                Text("\(dayOfWeek())")
                                    .bold()
                                    .padding(.leading, 20)
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                Text("В этот день нет пар")
                                    .font(.headline)
                                    .padding(.top, 280)
                                Spacer()
                            }
                        }
                        //.frame(width: 380, height: 800)
                    } else {
                        ScrollView {
                            HStack{
                                Text("\(dayOfWeek())")
                                    .bold()
                                    .padding(.leading, 20)
                                Spacer()
                            }
                            ForEach(events, id: \.id) { event in
                                VStack(alignment: .leading, spacing: 8) {
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
                                    
                                }
                                .padding(20)
                                .background(backgroundForValue(                            event.description.event))
                                .cornerRadius(20)
                                .onTapGesture {
                                    

                                    selectedEvent = event
                                    currentTitle = selectedEvent?.title ?? ""
                                    currentStart = selectedEvent?.start ?? Date()
                                    currentEnd = selectedEvent?.end ?? Date()
                                    currentBuilding = selectedEvent?.description.building ?? ""
                                    currentClassroom = selectedEvent?.description.classroom ?? ""
                                    currentEvent = selectedEvent?.description.event ?? ""
                                    currentProfessor = selectedEvent?.description.professor ?? ""
                                    currentDepartment = selectedEvent?.description.department ?? ""
                                    
                                    print("---\(currentTitle)")
                                    
                                    print("---\(event)")
                                    showDetails = true
                                }
                                .onChange(of: page.index){
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    dayWeek = data.dataBase.keys.sorted()[page.index]
                                    selectedDayOfWeek = dateFormatter.date(from: dayWeek) ?? Date()
                                    print("page changed\(selectedDayOfWeek)")
                                }
                                .frame(width: 320, alignment: .center)
                                .padding()
                                .cornerRadius(10)
                            }
                            
                        }
                    }
                } else {
                    Text("В этот день нет пар")
                        .font(.headline)
                        .padding()
                }
            }


            
                  .onChange(of: selectedDayOfWeek) {
                updatePagerIndex()
            }
            .onAppear {
                data.getClasses(group: UserDefaults.standard.string(forKey: "selectedGroup") ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    updatePagerIndex()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    updatePagerIndex()
                }
            }
        }
        .sheet(isPresented: $showDetails) {
                DetailView(                currentTitle: $currentTitle,
                                           currentStart: $currentStart,
                                           currentEnd: $currentEnd,
                                           currentBuilding: $currentBuilding,
                                           currentClassroom: $currentClassroom,
                                           currentEvent: $currentEvent,
                                           currentProfessor: $currentProfessor,
                                           currentDepartment: $currentDepartment,
                                           showDetails: $showDetails)
        }
    }

    func formatTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
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
    
    func dayOfWeek() -> String {
        let calendar = Calendar.current
        let components = calendar.component(.weekday, from: selectedDayOfWeek)
            switch components {
            case 1:
                return "Воскресенье"
            case 2:
                return "Понедельник"
            case 3:
                return "Вторник"
            case 4:
                return "Среда"
            case 5:
                return "Четверг"
            case 6:
                return "Пятница"
            case 7:
                return "Суббота"
            default:
                return ""
            }
        }

    func updatePagerIndex() {
        if let index = data.dataBase.keys.sorted().firstIndex(where: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return Calendar.current.isDate(selectedDayOfWeek, inSameDayAs: dateFormatter.date(from: $0) ?? Date())
        }) {
            page.update(.new(index: index))
        } else {
            // Обработка случая, когда выбранная дата отсутствует в dataBase
        }
    }

}
struct DetailView: View {
    
    @Binding var currentTitle: String
    @Binding var currentStart: Date
    @Binding var currentEnd: Date
    @Binding var currentBuilding: String
    @Binding var currentClassroom: String
    @Binding var currentEvent: String
    @Binding var currentProfessor: String
    @Binding var currentDepartment: String
    @Binding var showDetails: Bool
    
    var body: some View {
        ZStack{
            Color(backgroundForValue(currentEvent)).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 14) {
                Text("Подробная информация")
                    .bold()
                    .frame(width: 360, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("Название дисциплины: \(currentTitle)")
                    .underline()
                    .frame(width: 320, alignment: .leading)
                    .font(.subheadline)
                Text("Время: \(formatTime(from: currentStart)) - \(formatTime(from: currentEnd))")
                    .underline()
                    .font(.subheadline)
                Text("Здание: \(currentBuilding)")
                    .underline()
                    .font(.subheadline)
                Text("Аудитория: \(currentClassroom)")
                    .underline()
                    .font(.subheadline)
                Text("Событие: \(currentEvent)")
                    .underline()
                    .font(.subheadline)
                Text("Преподователь: \(currentProfessor)")
                    .underline()
                    .font(.subheadline)
                Text("Кафедра: \(currentDepartment)")
                    .underline()
                    .font(.subheadline)
                Spacer()
            }
            .padding(.top, 70)
            .foregroundStyle(Color.black)
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
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(data: Requesting())
    }
}




#Preview {
    MainView(data: Requesting())
}
