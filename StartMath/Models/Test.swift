//
//  Test.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 16/12/2020.
//

import Foundation
import RealmSwift

class Test: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionTest: String = ""
    @objc dynamic var answerA: String = ""
    @objc dynamic var answerB: String = ""
    @objc dynamic var answerC: String = ""
    @objc dynamic var answerD: String = ""
    @objc dynamic var answerCorrect: String = ""
    
    @objc dynamic var updatedAt: String = ""
    @objc dynamic var createdAt: String = ""
}
