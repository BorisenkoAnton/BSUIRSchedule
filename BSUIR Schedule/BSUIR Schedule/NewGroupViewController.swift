//
//  NewGroupViewController.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class NewGroupViewController: UIViewController {

    var groups = [Schedule.StudentGroup]()
    var groupNumbers = [String]()
    @IBOutlet weak var groupNumbersPickerView: UIPickerView!
    @IBOutlet weak var groupNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()
    }
    
    func loadScheduleForNewGroup(completion: @escaping (DBmodel) -> ()) {
        
        guard groupNumberTextField.text != "" else { return }
        
        if groupNumbers.contains(groupNumberTextField.text!) {
            NetworkManager.getScheduleForGroup(groupNumberTextField.text!) { (schedule) in
                completion(schedule)
            }
        } else {
            // TODO: add alert
        }
    }
    
    private func setupScreen() {
        
        if !groupNumbers.isEmpty {
            groupNumbersPickerView.reloadAllComponents()
            for a in groupNumbers {
                print(a)
            }
            
        } else {
            print("is empty")
        }
    }
    
}

// MARK: - Table View Delegate and Data Source

extension NewGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let set = NSCharacterSet(charactersIn: "0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: set)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
