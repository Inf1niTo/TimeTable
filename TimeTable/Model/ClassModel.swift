//
//  ClassModel.swift
//  Raspisanie_2
//
//  Created by Антон Плотников on 15.01.2024.
//

import Foundation


struct Event: Codable {
    let id: Int
    let title: String
    let color: String
    let start: Date
    let end: Date
    let description: EventDescription

    private enum CodingKeys: String, CodingKey {
        case id, title, color, start, end, description
    }
}

struct EventDescription: Codable {
    let building: String
    let classroom: String
    let event: String
    let professor: String
    let department: String
}


struct NewsItem: Codable, Equatable {
    let imageUrl: String
    let title: String
    let description: String
    let date: String
    let href: String

    private enum CodingKeys: String, CodingKey {
        case imageUrl, title, description, date, href
    }

    // Реализация протокола Equatable
    static func ==(lhs: NewsItem, rhs: NewsItem) -> Bool {
        return lhs.imageUrl == rhs.imageUrl &&
               lhs.title == rhs.title &&
               lhs.description == rhs.description &&
               lhs.date == rhs.date &&
               lhs.href == rhs.href
    }
}

