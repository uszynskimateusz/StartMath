//
//  Flashcard.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 16/12/2020.
//

import Foundation
import RealmSwift

class Flashcard: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionFlashcard: String = ""
    @objc dynamic var image: NSData = NSData()
    
    @objc dynamic var updatedAt: String = ""
    @objc dynamic var createdAt: String = ""
}
