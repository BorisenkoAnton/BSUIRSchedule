//
//  ScheduleManager.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/19/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

// Helper class to manage different manipulations with schedule and additional data
class ScheduleManager {
    
    static func getCurrentWeekDay() -> Int {
        
        let date = Date()
        let calendar = Calendar.current
        var weekday = calendar.component(.weekday, from: date)
        
        switch weekday {
        case 1:
            // weekday == 1 means that it is sunday
            weekday = 6
        default:
            // need to substract 2 because in Calendar week starts from Sunday and with index 1
            weekday -= 2
        }
        
        print(weekday)
        return weekday
    }
    
    static func getCurrentDaySchedule(weekNumber: Int, weekDay: Int, schedule: Schedule) -> [LessonInfo] {
        
        guard weekDay != 6 else { return [] }
        
        let fullSchedeule = schedule.schedules[weekDay]
        var lessonInfoArray = [LessonInfo]()
        for lesson in fullSchedeule.schedule {
            if lesson.weekNumber.contains(weekNumber) {
                let lessonInfo = LessonInfo(from: lesson)
                lessonInfoArray.append(lessonInfo)
            }
        }
        
        return lessonInfoArray
    }
    
    static func getWeekDayAndNumber(weekNumber: Int, weekDay: Int, groupNumber: String) -> String {
        
        var day = ""
        
        switch weekDay {
        case 0:
            day = "monday"
        case 1:
            day = "tuesday"
        case 2:
            day = "wednesday"
        case 3:
            day = "thursday"
        case 4:
            day = "friday"
        case 5:
            day = "saturday"
        case 6:
            day = "sunday"
        default:
            day = "unknown"
        }
        
        let weekDayAndNumber = day + ", \(weekNumber) week (" + groupNumber + ")"
        
        return weekDayAndNumber
    }
}
