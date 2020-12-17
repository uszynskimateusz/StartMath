//
//  IntroductionData.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import Foundation

//main
struct IntroductionData: Decodable {
    let items: [ItemsIntroduction]
}

//main --> "items: []"
struct ItemsIntroduction: Decodable {
    let fields: FieldsIntroduction
    let sys: SysINFO
}

//main --> "items: []" --> fields
struct FieldsIntroduction: Decodable {
    let title: String
    let description: String
}

struct SysINFO: Decodable {
    let id: String
    let updatedAt: String
    let createdAt: String
}
