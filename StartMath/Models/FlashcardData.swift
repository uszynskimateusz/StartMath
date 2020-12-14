//
//  FlashcardData.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import Foundation

//main
struct FlashcardData: Decodable {
    let items: [ItemsFlashcard]
    let includes: IncludeImage
}

//main --> "items: []"
struct ItemsFlashcard: Decodable {
    let fields: FieldsFlashcard
    let sys: Sys
}

//main --> "items: []" --> fields
struct FieldsFlashcard: Decodable {
    let title: String
    let description: String
    
    let image: ImageImage
}
