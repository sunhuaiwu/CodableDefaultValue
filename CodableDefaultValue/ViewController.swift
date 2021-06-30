//
//  ViewController.swift
//  CodableDefaultValue
//
//  Created by 孙怀武 on 2021/6/30.
//

import UIKit

struct HWGender: RawRepresentable, Codable {
    var rawValue: Int
    static let male = HWGender(rawValue: 0)
    static let female = HWGender(rawValue: 1)
}
extension HWGender: HWDefaultValue {
    static var defaultValue = HWGender(rawValue: 0)
}
 
struct Person: Codable {
    @HWDefault<String.UNNAMED> var name: String
    @HWDefault<HWIntOrString> var age: HWIntOrString
    @HWDefault<String.NULL> var address: String
    @HWDefault<HWGender> var gender: HWGender
    
    func toString() -> String {
        return "name: \(name), age:\(age.int), address: \(address), gender: \(gender.rawValue)"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonData1 = """
            {"name":"sunhuaiwu","age":"18", "address":"sccd","gender":1}
        """.data(using: .utf8)!
        
        let jsonData2 = """
            {"name2":"sunhuaiwu","age2":"18", "address2":"sccd","gender2":1}
        """.data(using: .utf8)!
        
        let jsonData3 = """
            {"name":null,"age":null, "address":null,"gender":100}
        """.data(using: .utf8)!
        
        do {
            let p1 = try JSONDecoder().decode(Person.self, from: jsonData1)
            print(p1.toString())
            
            let p2 = try JSONDecoder().decode(Person.self, from: jsonData2)
            print(p2.toString())
            
            let p3 = try JSONDecoder().decode(Person.self, from: jsonData3)
            print(p3.toString())
        } catch let e {
            print(e)
        }
    }
}

