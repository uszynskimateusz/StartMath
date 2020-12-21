//
//  ExerciseData.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 14/12/2020.
//

import Foundation

//main
struct ExerciseData: Decodable {
    let items: [ItemsExercise]
    let includes: IncludeImage
}

//main --> "items: []"
struct ItemsExercise: Decodable {
    let fields: FieldsExercise
    let sys: SysINFO
}

//main --> "items: []" --> fields
struct FieldsExercise: Decodable {
    let title: String
    let description: String
    let answer: String
    
    let image: ImageImage
}

//main --> "items: []" --> "fields" --> "image"
struct ImageImage: Decodable {
    let sys: SysExercise
}

//main --> "items: []" --> "fields" --> "image" --> "sys"
struct SysExercise: Decodable {
    let id: String
}

//main --> "includes"
struct IncludeImage: Decodable {
    let Asset: [AssetsImage]
}

//main --> "includes" --> "Asset: []"
struct AssetsImage: Decodable {
    let sys: SysImageFirst
    let fields: FieldImage
}
//main --> "includes" --> "Asset: []" --> "sys"
struct SysImageFirst: Decodable {
    let id: String
}

//main --> "includes" --> "Asset: []" --> "fields"
struct FieldImage: Decodable {
    let file: FileImage
}

//main --> "includes" --> "Asset: []" --> "fields" --> "file"
struct FileImage: Decodable {
    let url: String
}
