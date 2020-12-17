//
//  TestData.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import Foundation

//main
struct TestData: Decodable {
    let items: [ItemsTest]
}

//main --> "items: []"
struct ItemsTest: Decodable {
    let fields: FieldsTest
    let sys: SysINFO
}

//main --> "items: []" --> fields
struct FieldsTest: Decodable {
    let title: String
    let description: String
    let answerA: String
    let answerB: String
    let answerC: String
    let answerD: String
    let answerCorrect: String
}
