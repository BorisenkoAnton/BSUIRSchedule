//
//  ScheduleTableViewController.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/11/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class ScheduleTableViewController: UITableViewController {
    
    private var savedSchedules: Results<DBmodel>!
    private var schedules = [Schedule]()
    private var currentWeekNumber = 1
    private var currentWeekDay = 0
    private var lessons = [LessonInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.getCurrentWeekNumber() { (response) in
            self.currentWeekNumber = response
        
            self.currentWeekDay = ScheduleManager.getCurrentWeekDay()
            
            self.savedSchedules = realm.objects(DBmodel.self)
            for savedSchedule: DBmodel in self.savedSchedules {

                let json = Data(savedSchedule.jsonRepresentationOfSchedule.utf8)
                do {
                    let schedule = try JSONDecoder().decode(Schedule.self, from: json)
                    self.schedules.append(schedule)
                } catch {
                    print(error)
                }
            }
            
            self.lessons = ScheduleManager.getCurrentDaySchedule(weekNumber: self.currentWeekNumber, weekDay: self.currentWeekDay, schedule: self.schedules[0])
            
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleTableViewCell
        
        guard !lessons.isEmpty else { return UITableViewCell() }
        
        let lesson = lessons[indexPath.row]
        
        cell.professorNameLabel.text = lesson.professorName
        cell.subjectNameLabel.text = lesson.subjectName
        cell.subjectTypeLabel.text = lesson.lessonType
        cell.subjectTimeLabel.text = lesson.lessonTime
        cell.subjectAuditoryLabel.text = lesson.auditorium
        if lesson.professorsPhoto != nil {
            cell.professorsPhoto.image = lesson.professorsPhoto
        }
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Groups" {
            
            let newGroupVC = segue.destination as! NewGroupViewController
            
            for schedule in schedules {
                newGroupVC.groups.append(schedule.studentGroup)
            }
            
        }
        
    }

}
