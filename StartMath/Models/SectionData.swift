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
    let sys: SysSection
}

struct Fields: Decodable {
    let title: String
    
    let introduction: FieldsOfSection
    let flashcards: [FieldsOfSection]
    let exercises: [FieldsOfSection]
    let test: [FieldsOfSection]
}

struct FieldsOfSection: Decodable {
    let sys: Sys
}

struct Sys: Decodable {
    let id: String
}

struct SysSection: Decodable {
    let updatedAt: String
    let createdAt: String
}
