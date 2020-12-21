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
    @objc dynamic var createdAt: String = ""
    
    var introductions = List<Introduction>()
    var exercises = List<Exercise>()
    var flashcards = List<Flashcard>()
    var tests = List<Test>()
}
