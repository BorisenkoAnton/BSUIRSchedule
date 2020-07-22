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
    private var currentScedule: Schedule?
    private var lessons = [LessonInfo]()
    private var groupNumbers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGestureRecognizers()
        NetworkManager.getCurrentWeekNumber() { (response) in
            self.currentWeekNumber = response
            print(response)
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
            
            if !self.schedules.isEmpty {
                
                self.currentScedule = self.schedules[0]
                
                self.lessons = ScheduleManager.getCurrentDaySchedule(weekNumber: self.currentWeekNumber, weekDay: self.currentWeekDay, schedule: self.currentScedule!)
                
                self.tableView.reloadData()
            }
        }
        
        NetworkManager.getAllGroupNumbers() { (groupNumbers) in

            self.groupNumbers = groupNumbers
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
            newGroupVC.groupNumbers = groupNumbers
        }
        
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {

        guard let newGroupVC = segue.source as? NewGroupViewController else { return }
        
        newGroupVC.loadScheduleForNewGroup() { (schedule) in
            let json = Data(schedule.jsonRepresentationOfSchedule.utf8)
            do {
                let newSchedule = try JSONDecoder().decode(Schedule.self, from: json)
                self.schedules.append(newSchedule)
                self.currentScedule = newSchedule
                self.lessons = ScheduleManager.getCurrentDaySchedule(weekNumber: self.currentWeekNumber, weekDay: self.currentWeekDay, schedule: self.currentScedule!)
                self.tableView.reloadData()
            } catch {
                print(error)
            }
            
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Gesture Recognizing
    
    func addSwipeGestureRecognizers() {
        
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        rightGestureRecognizer.direction = .right
        self.view.addGestureRecognizer(rightGestureRecognizer)
        
        let leftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        leftGestureRecognizer.direction = .left
        self.view.addGestureRecognizer(leftGestureRecognizer)
    }

    @objc func handleSwipe(gesture: UIGestureRecognizer) {
        
        if let gesture = gesture as? UISwipeGestureRecognizer {
            
            switch gesture.direction {
            case .right:
                guard self.currentScedule != nil else { return }
                
                changeCurrentWeekDay(increase: false)
                self.lessons = ScheduleManager.getCurrentDaySchedule(weekNumber: self.currentWeekNumber, weekDay: self.currentWeekDay, schedule: self.currentScedule!)
                self.tableView.reloadData()
            case .left:
                guard self.currentScedule != nil else { return }
                
                changeCurrentWeekDay(increase: true)
                self.lessons = ScheduleManager.getCurrentDaySchedule(weekNumber: self.currentWeekNumber, weekDay: self.currentWeekDay, schedule: self.currentScedule!)
                self.tableView.reloadData()
            default:
                break
            }
        }
    }
    
    func changeCurrentWeekDay(increase: Bool) {
        
        if increase {
            self.currentWeekDay += 1
            if self.currentWeekDay > 6 {
                self.currentWeekNumber += 1
                self.currentWeekDay = 0
                if self.currentWeekNumber > 4 {
                    self.currentWeekNumber = 1
                }
            }
        } else {
            self.currentWeekDay -= 1
            if self.currentWeekDay < 0 {
                self.currentWeekNumber -= 1
                self.currentWeekDay = 6
                if self.currentWeekNumber < 1 {
                    self.currentWeekNumber = 4
                }
            }
        }
    }
    
}
