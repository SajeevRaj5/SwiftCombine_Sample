//
//  EmployeeViewCell.swift
//  CombineSample
//
//  Created by sajeev Raj on 7/18/20.
//  Copyright © 2020 CombineSample. All rights reserved.
//

import UIKit
import Combine

class EmployeeViewCell: UITableViewCell {
    
    var cancelables: [AnyCancellable] = []
    
    var viewModel: EmployeeViewModel? {
        didSet {
            configureView()
        }
    }

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseView.layer.cornerRadius = 10.0
        baseView.layer.borderWidth = 1.0
        
        configureView()
    }
    
    func configureView() {
        guard let viewmodel = viewModel else { return }
        self.cancelables = [
            viewmodel.id.assign(to: \.text, on: idLabel),
            viewmodel.age.assign(to: \.text, on: ageLabel),
            viewmodel.salary.assign(to: \.text, on: salaryLabel),
            viewmodel.name.assign(to: \.text, on: nameLabel)
        ]
    }

}
