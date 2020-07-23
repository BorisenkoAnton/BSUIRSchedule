//
//  NetworkManager.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/11/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

// Class to manage data retrieval from BSUIR server
class NetworkManager {
    
    static func getScheduleForGroup(_ groupNumber: String, completion: @escaping (DBmodel) -> ()) {
        
        let url =  "https://journal.bsuir.by/api/v1/studentGroup/schedule?studentGroup=" + groupNumber
        AlamofireNetworkRequest.sendGetRequestForString(url: url) { (stringRepresentationOfSchedule) in
            if let schedule = DBmodel(jsonRepresentationOfSchedule: stringRepresentationOfSchedule, groupNumber: Int(groupNumber)!) {
                StorageManager.saveObject(schedule)
                completion(schedule)
            }
        }
    }
    
    static func getCurrentWeekNumber(completion: @escaping (_ currentWeekNumber: Int) -> ()) {
        
        let url = "https://journal.bsuir.by/api/v1/week"
        AlamofireNetworkRequest.sendGetRequestForString(url: url) { (currentWeekNumberString) in
            guard let currentWeekNumber = Int(currentWeekNumberString) else { return }
            completion(currentWeekNumber)
        }
    }
    
    static func getAllGroupNumbers(completion: @escaping (_ groupNumbers: [String]) -> ()) {
        
        let url = "https://journal.bsuir.by/api/v1/groups"
        
        AlamofireNetworkRequest.sendGetRequestForData(url: url) { (json) in
            
            var groupNumbers = [String]()
            
            do {
                let groups = try JSONDecoder().decode([Schedule.StudentGroup].self, from: json)
                
                for group in groups {
                    groupNumbers.append(group.name)
                }
                
                groupNumbers.sort()
            } catch {
                // TODO: insert alert here
            }
            
            completion(groupNumbers)
        }
    }
}
