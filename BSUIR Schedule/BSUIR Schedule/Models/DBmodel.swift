//
//  DBmodel.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/11/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

// Data model to save to data base with Realm
class DBmodel: Object {
    @objc dynamic var jsonRepresentationOfSchedule = ""
    @objc dynamic var groupNumber = 0

    convenience init?(jsonRepresentationOfSchedule: String, groupNumber: Int) {
        self.init()
        self.jsonRepresentationOfSchedule = jsonRepresentationOfSchedule
        self.groupNumber = groupNumber
    }
}
