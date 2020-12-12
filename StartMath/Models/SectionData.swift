//
//  SectionData.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 12/12/2020.
//

import Foundation

struct SectionData: Decodable {
    let items: [Items]
}

struct Items: Decodable {
    let fields: Fields
}

struct Fields: Decodable {
    let title: String
    
    let introduction: FieldsOfSection
    let flashcard: FieldsOfSection
    let exercise: FieldsOfSection
    let test: FieldsOfSection
}

struct FieldsOfSection: Decodable {
    let sys: Sys
}

struct Sys: Decodable {
    let id: String
}
