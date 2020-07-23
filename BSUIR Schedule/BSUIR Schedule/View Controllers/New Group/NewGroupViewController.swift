//
//  NewGroupViewController.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

class NewGroupViewController: UIViewController {

    var groups = [Schedule.StudentGroup]()
    var groupNumbers = [String]()
    var savedSchedules: Results<DBmodel>!
    @IBOutlet weak var groupNumbersPickerView: UIPickerView!
    @IBOutlet weak var groupNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()
    }
    
    func loadScheduleForNewGroup(completion: @escaping (DBmodel) -> ()) {
        
        guard groupNumberTextField.text != "" else { return }
        
        for savedSchedule in savedSchedules {
            // If we already have schedule saved locally, we return it instead of loading
            if String(savedSchedule.groupNumber) == groupNumberTextField.text {
                completion(savedSchedule)
                return
            }
        }
        
        // Checking if group number exists and loading new schedule
        if groupNumbers.contains(groupNumberTextField.text!) {
            NetworkManager.getScheduleForGroup(groupNumberTextField.text!) { (schedule) in
                completion(schedule)
            }
        } else {
            // TODO: add alert
        }
    }
    
    // Added group numbers to picker view
    private func setupScreen() {
        
        if !groupNumbers.isEmpty {
            groupNumbersPickerView.reloadAllComponents()
        } else {
            print("is empty")
        }
    }
    
}

// MARK: - Table View Delegate and Data Source

extension NewGroupViewController: UITableViewDelegate {
    
    // If row is selected, add selected group number to text field
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! NewGroupTableViewCell
        groupNumberTextField.text = cell.groupNumberLabel.text!
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! NewGroupTableViewCell
        
        guard !groups.isEmpty else { return UITableViewCell() }
        
        let group = groups[indexPath.row]
        
        cell.groupNumberLabel.text = group.name
        cell.specialityLabel.text = group.specialityName
        cell.courseLabel.text = String(group.course!) + " course"
        
        return cell
        
    }
    
    // Deleting saved group
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let group = groups[indexPath.row]
        groups.remove(at: indexPath.row)
        
        for savedSchedule in savedSchedules {
            if String(savedSchedule.groupNumber) == group.name {
                StorageManager.deleteObject(savedSchedule)
                break
            }
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in

            tableView.deleteRows(at: [indexPath], with: .automatic)
            print(group.name)
        }
        
        return [deleteAction]
    }
    
}


// MARK: - Picker View Data Source and Delegate

extension NewGroupViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        groupNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupNumbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.groupNumberTextField.text = self.groupNumbers[row]
    }
}

extension NewGroupViewController: UIPickerViewDelegate {}

extension NewGroupViewController: UITextFieldDelegate {
    
    // To deprecate any symbols except numbers
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let set = NSCharacterSet(charactersIn: "0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: set)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
