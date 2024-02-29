//
//  LoginViewModel.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 11.11.23.
//

import Foundation
import SwiftyJSON

class LoginViewModel : ObservableObject{
    @Published var currentUser: User
    @Published private(set) var state = State.ready
    
    enum State{
        case ready
        case loading
        case failed
    }
    
    private var authService: AuthService

        init(authService: AuthService) {
            self.authService = authService
            self.currentUser = User()
        }
    
    func login(complete: @escaping (_ success: Bool, _ response: JSON) -> Void){
        state = .loading
        authService.login(email: currentUser.email, password: currentUser.password){
            success, response in
            if(success){
                UserDefaults.standard.set(response["access_token"].stringValue, forKey: "token")
            }
            complete(success, response)
            self.state = .ready
        }
        //state = .ready
    }
    
    func loginWithToken(complete: @escaping (_ success: Bool, _ response: JSON) -> Void){
        state = .loading
        let token = UserDefaults.standard.string(forKey: "token")
        if let token {
            authService.loginWithToken(token: token){
                success, response in
                complete(success, response)
                self.state = .ready
            }
        }
        else
        {
            complete(false, JSON())
            self.state = .ready
        }
    }
    
    func loginByQr(token: String, complete: @escaping (_ success: Bool, _ response: JSON) -> Void){
        state = .loading
        authService.loginWithToken(token: token){
            success, response in
            if(success){
                UserDefaults.standard.set(token, forKey: "token")
            }
            complete(success, response)
            self.state = .ready
        }
    }
}
