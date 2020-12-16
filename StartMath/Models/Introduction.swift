//
//  Introduction.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 16/12/2020.
//

import Foundation
import RealmSwift

class Introduction: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionIntroduction: String = ""
}
