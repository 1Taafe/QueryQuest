//
//  AuthService.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 14.11.23.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class AuthService{
    
    func getUserProfile(token: String, complete: @escaping (_ success: Bool, _ response: User) -> Void){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
        ]
        
        AF.request("\(Service.url)/auth/profile", method: .get, headers: headers).response { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value!)
                if let user = User.parse(from: json) {
                    complete(true, user)
                } else {
                    print("Failed to parse user")
                }
            case .failure(let error):
                print(error)
                complete(false, User())
            }
        }
    }
    
    func login(email: String, password: String, complete: @escaping (_ success: Bool, _ response: JSON) -> Void){

        let loginDto = LoginDto(email: email, password: password)

        AF.request("\(Service.url)/auth/login", method: .post, parameters: loginDto)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    if let json = response.data {
                        do {
                            let data = try JSON(data: json)
                            complete(true, data)
                        } 
                        catch {
                            debugPrint("error")
                        }
                    }
                case .failure:
                    if let json = response.data {
                        do {
                            let data = try JSON(data: json)
                            complete(false, data)
                        } 
                        catch {
                            debugPrint("error")
                        }
                    }
                }
        }
    }
    
    func loginWithToken(token: String, complete: @escaping (_ success: Bool, _ response: JSON) -> Void){

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
        ]
        
        AF.request("\(Service.url)/auth/checkToken", method: .get, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    if let json = response.data {
                        do {
                            let data = try JSON(data: json)
                            complete(true, data)
                        }
                        catch {
                            debugPrint("error")
                        }
                    }
                case .failure:
                    if let json = response.data {
                        do {
                            let data = try JSON(data: json)
                            complete(false, data)
                        }
                        catch {
                            debugPrint("error")
                        }
                    }
                }
        }
    }
}
