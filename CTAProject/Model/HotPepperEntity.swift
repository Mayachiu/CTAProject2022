//
//  HotPepperEntity.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/16.
//

import Foundation

struct HotPepper: Codable {
    let results: Results
}

struct Results: Codable {
    let shop: [Shop]

    enum CodingKeys: String, CodingKey {
        case shop
    }
}

struct Shop: Codable {
    let name: String
    let budget: Budget
    let genre: Genre
    let smallArea: SmallArea
    let logoImage: String
    let stationName: String

    enum CodingKeys: String, CodingKey {
        case name
        case budget
        case genre
        case smallArea = "small_area"
        case logoImage = "logo_image"
        case stationName = "station_name"
    }
}

struct Budget: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct Genre: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct SmallArea: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
