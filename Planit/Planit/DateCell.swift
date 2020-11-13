//
//  DateCell.swift
//  Planit
//
//  Created by Jiye Choi on 11/11/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import Foundation
import JTAppleCalendar
import UIKit

class DateCell: JTAppleCell{
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var eventbarView: UIView!
    @IBOutlet var selectView: UIView!
    @IBOutlet var todayView: UIView!
    @IBOutlet weak var eventdotView: UIImageView!
}
