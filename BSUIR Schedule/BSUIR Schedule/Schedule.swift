//
//  Schedule.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/19/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation

// model for data get from https://journal.bsuir.by/api/v1/studentGroup/schedule?studentGroup=XXXXXX
public struct Schedule: Decodable {
    
    public var employee: Employee?
    public var studentGroup: StudentGroup
    public var schedules: [FullSchedule]
    public var examSchedules: [FullSchedule]
    public var todayDate: String
    public var todaySchedules: [FullSchedule]
    public var tomorrowDate: String
    public var tomorrowSchedules: [FullSchedule]
    public var currentWeekNumber: Int
    public var dateStart: String
    public var dateEnd: String
    public var sessionStart: String?
    public var sessionEnd: String?
}

// added needed structs for Schedule model
extension Schedule {
    
    public struct FullSchedule: Decodable {
        
        public var weekDay: String
        public var schedule: [Lesson]
    }
    
    public struct Employee: Decodable {
        
        public var firstName: String
        public var lastName: String
        public var middleName: String
        public var rank: String?
        public var photoLink: String?
        public var calendarId: String
        public var academicDepartment: [String]
        public var id: Int
        public var fio: String
    }

    public struct StudentGroup: Decodable {
        
        public var name: String
        public var facultyId: Int
        public var facultyName: String?
        public var specialityDepartmentEducationFormId: Int
        public var specialityName: String?
        public var course: Int?
        public var id: Int
        public var calendarId: String?
    }
}

extension Schedule.FullSchedule {
        
    public struct Lesson: Decodable {
        
        public var weekNumber: [Int]
        public var studentGroup: [String]
        public var numSubgroup: Int
        public var auditory: [String]
        public var lessonTime: String
        public var startLessonTime: String
        public var endLessonTime: String
        public var subject: String
        public var note: String?
        public var lessonType: String
        public var employee: [Schedule.Employee]
        public var zaoch: Bool
    }
}
