//
//  Employee.swift
//  CombineSample
//
//  Created by sajeev Raj on 7/18/20.
//  Copyright © 2020 CombineSample. All rights reserved.
//

import Foundation
import Combine

struct EmployeeResponse: Codable {
    var status: String
    var data: [Employee]
}

// MARK: - Employee
class Employee: Codable {
    var id, employeeName, employeeSalary, employeeAge: String
    var profileImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case employeeName   = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge    = "employee_age"
        case profileImage   = "profile_image"
    }
    
    required init() {
        self.id            = ""
        self.employeeName   = ""
        self.employeeSalary = ""
        self.employeeAge    = ""
        self.profileImage   = ""
    }
    
    deinit {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        employeeName = try container.decode(String.self, forKey: .employeeName)
        employeeSalary = try container.decode(String.self, forKey: .employeeSalary)
        employeeAge = try container.decode(String.self, forKey: .employeeAge)
        profileImage = try container.decode(String.self, forKey: .profileImage)
    }
    
    func getDetails( completion: @escaping (Result<[Employee], RequestError>) -> ()) {
        Router.employees.request { (response: ServiceResponse<EmployeeResponse>) in
            switch response {
            case .success(let result):
                print(result)
                completion(.success(result.data))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            case .finally:
                print("final")
            }
        }
    }
}

extension Employee {
    enum Router: Requestable {
        case employees
        
        var path: String {
            switch self {
            case .employees: return "employees"
            }
        }
        
        var parameters: [String : String] {
            return [:]
        }
    }
}

extension Array where Element == Employee {
    var viewModels: [EmployeeViewModel] {
        return map{ return EmployeeViewModel(model: $0) }
    }
}
