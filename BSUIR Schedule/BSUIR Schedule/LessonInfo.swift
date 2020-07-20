//
//  LessonInfo.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/19/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

// model, using in app. This data will be displayed on the main screen
public struct LessonInfo {
    
    public var professorsPhoto: UIImage?
    public var subjectName: String
    public var auditorium: String?
    public var lessonType: String
    public var lessonTime: String
    public var professorName: String?
}

extension LessonInfo {
    
    init(from lesson: Schedule.FullSchedule.Lesson) {
        if !lesson.auditory.isEmpty {
            self.auditorium = lesson.auditory[0]
        }
        self.lessonTime = lesson.startLessonTime + " - " + lesson.endLessonTime
        self.lessonType = lesson.lessonType
        if !lesson.employee.isEmpty {
            self.professorName = lesson.employee[0].fio
            if lesson.employee[0].photoLink != nil {
                let photoURL = URL(string: lesson.employee[0].photoLink!)!
                if let photo = try? Data(contentsOf: photoURL) {
                    self.professorsPhoto = UIImage(data: photo as Data)
                }
            }
            
        } 
        self.subjectName = lesson.subject
        if lesson.numSubgroup != 0 {
            self.lessonType += " (\(lesson.numSubgroup) п.)"
        }
    }
}
