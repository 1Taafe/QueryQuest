//
//  HomeViewModel.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 25.11.23.
//

import Foundation

class HomeViewModel : ObservableObject{

    private var olympicsService: OlympicsService = OlympicsService()
    private var authService: AuthService = AuthService()
    @Published private(set) var state = State.ready
    @Published private(set) var sheetState = State.ready
    @Published var selectedOlympics: [Olympics] = []
    @Published var currentUser: User = User()
    
    enum State{
        case ready
        case loading
        case failed
    }
    
    func getUserInfo(){
        sheetState = .loading
        let token = UserDefaults.standard.string(forKey: "token")!
        authService.getUserProfile(token: token){
            success, user in
            if(success){
                self.currentUser = user
                print(user)
                self.sheetState = .ready
            }
            else{
                self.sheetState = .ready
            }
        }
    }
    
    func getOlympics(path: String){
        state = .loading
        let token = UserDefaults.standard.string(forKey: "token")!
        olympicsService.getOlympics(path: path, token: token){
            success, olympics in
            if(success){
                self.selectedOlympics = olympics
                print(self.selectedOlympics)
                self.state = .ready
            }
            else{
                self.state = .ready
            }
        }
    }
    
    func signOut(){
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
