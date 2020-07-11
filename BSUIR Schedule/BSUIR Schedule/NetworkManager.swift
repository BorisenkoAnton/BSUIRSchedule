//
//  NetworkManager.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/11/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static func getScheduleForGroup(_ groupNumber: String) {
        
        let url =  "https://journal.bsuir.by/api/v1/studentGroup/schedule?studentGroup=" + groupNumber
        AlamofireNetworkRequest.sendGetRequestForString(url: url) { (stringRepresentationOfSchedule) in
            if let schedule = DBmodel(jsonRepresentationOfSchedule: stringRepresentationOfSchedule, groupNumber: Int(groupNumber)!) {
                //StorageManager.saveObject(schedule)
                print(stringRepresentationOfSchedule)
            }
        }
    }
}
