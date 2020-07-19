//
//  ViewController.swift
//  CombineSample
//
//  Created by sajeev Raj on 7/17/20.
//  Copyright © 2020 CombineSample. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var employeeViewModels: [EmployeeViewModel]? {
        didSet {
            listTableView.reloadData()
        }
    }

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Employee Details"
        
        fetchEmployeeDetails()
    }
    
    func fetchEmployeeDetails() {
        Employee().getDetails { [weak self] (response) in
            switch response {
            case .success(let employees):
                print(employees)
                self?.employeeViewModels = employees.viewModels
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeViewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeViewCell", for: indexPath) as? EmployeeViewCell else { return UITableViewCell() }
        cell.viewModel = employeeViewModels?[indexPath.row]
        return cell
    }
}

