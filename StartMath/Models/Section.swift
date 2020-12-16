//
//  Section.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 16/12/2020.
//

import Foundation
import RealmSwift

class Section: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var updatedAt: String = ""
    
    let introductions = List<Introduction>()
    let exercises = List<Exercise>()
    let flashcards = List<Flashcard>()
    let tests = List<Test>()
}
