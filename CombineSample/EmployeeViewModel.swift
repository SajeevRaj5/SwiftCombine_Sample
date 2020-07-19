//
//  EmployeeViewModel.swift
//  CombineSample
//
//  Created by sajeev Raj on 7/18/20.
//  Copyright © 2020 CombineSample. All rights reserved.
//

import Foundation
import Combine

class EmployeeViewModel {
    enum State {
        case initial
        case error(message: String)
    }
    
    var id = CurrentValueSubject<String?, Never>(nil)
    var name = CurrentValueSubject<String?, Never>(nil)
    var salary = CurrentValueSubject<String?, Never>(nil)
    var age = CurrentValueSubject<String?, Never>(nil)
    
    let employee: Employee
    let state = CurrentValueSubject<State, Never>(.initial)

    init(model: Employee) {
        self.employee = model
        
        _ = state.sink(receiveValue: { (state) in
            self.processState(state)
        })
    }
    
    func processState(_ state: State) {
        switch state {
        case .initial:
            id.value = employee.id
            name.value = employee.employeeName
            salary.value = employee.employeeSalary
            age.value = employee.employeeAge
        case .error(let message):
            print(message)
        }
    }
}
