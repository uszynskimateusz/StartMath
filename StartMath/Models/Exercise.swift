//
//  Exercise.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 16/12/2020.
//

import Foundation
import RealmSwift

class Exercise: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionExercise: String = ""
    @objc dynamic var answer: String = ""
    @objc dynamic var image: NSData = NSData()
    @objc dynamic var modelar: String = ""
    @objc dynamic var arMode: String = ""
    @objc dynamic var done: Bool = false
    
    @objc dynamic var updatedAt: String = ""
    @objc dynamic var createdAt: String = ""
}
