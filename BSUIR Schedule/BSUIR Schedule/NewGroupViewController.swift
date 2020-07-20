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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
// MARK: - Navigation
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
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
