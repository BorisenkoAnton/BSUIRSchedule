//
//  ScheduleTableViewCell.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/11/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var professorsPhoto: UIImageView! {
        didSet {
            // to make image view to be circle
            professorsPhoto.layer.cornerRadius = professorsPhoto.frame.size.height / 2
            professorsPhoto.clipsToBounds = true
        }
    }
    @IBOutlet weak var professorNameLabel: UILabel!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var subjectTypeLabel: UILabel!
    @IBOutlet weak var subjectTimeLabel: UILabel!
    @IBOutlet weak var subjectAuditoryLabel: UILabel!
}
