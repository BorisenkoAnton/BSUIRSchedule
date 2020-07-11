//
//  StorageManager.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/11/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ schedule: DBmodel) {
        
        try! realm.write {
            realm.add(schedule)
        }
    }
    
    static func deleteObject(_ schedule: DBmodel) {
        
        try! realm.write {
            realm.delete(schedule)
        }
    }
}
