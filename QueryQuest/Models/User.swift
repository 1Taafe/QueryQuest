//
//  User.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 11.11.23.
//

import Foundation
import SwiftyJSON

struct User {
    var email: String
    var password: String
    var course: Int
    var group: Int
    var surname: String
    var name: String
    var phone: String?
    var role: String
    
    init(){
        email = ""
        password = ""
        surname = ""
        name = ""
        course = 0
        group = 0
        role = ""
    }
    
    init(email: String, course: Int, group: Int, surname: String, name: String, phone: String, role: String)
    {
        self.email = email
        self.password = ""
        self.surname = surname
        self.name = name
        self.course = course
        self.group = group
        self.role = role
    }
    
    static func parse(from json: JSON) -> User? {
        guard
            let email = json["email"].string,
            let course = json["course"].int,
            let group = json["group"].int,
            let surname = json["surname"].string,
            let name = json["name"].string,
            let role = json["role"].string
        else {
            return nil
        }

        let phone = json["phone"].string ?? ""

        return User(email: email, course: course, group: group, surname: surname, name: name, phone: phone, role: role)
    }
}
