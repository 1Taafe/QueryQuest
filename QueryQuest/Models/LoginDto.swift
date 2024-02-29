//
//  LoginDto.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 14.11.23.
//

import Foundation

class LoginDto : Encodable{
    let email: String
    let password: String
    
    init(email: String, password: String){
        self.email = email
        self.password = password
    }
}
