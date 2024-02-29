//
//  OlympicsViewModel.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 9.12.23.
//

import Foundation

class OlympicsViewModel : ObservableObject{
    
    @Published private(set) var state = State.ready
    @Published var selectedTasks: [Task] = []
    @Published var result: Result = Result(totalScore: -1, maxTime: Date.now, userId: -1, place: -1)
    private var olympicsService: OlympicsService = OlympicsService()
    
    enum State{
        case ready
        case loading
    }
    
    func getResult(olympicsId: Int, complete: @escaping (_ success: Bool, _ resposnse: Result) -> Void){
        state = .loading
        let token = UserDefaults.standard.string(forKey: "token")!
        olympicsService.getResult(olympicsId: olympicsId, token: token){
            success, result in
            if(success){
                self.result = result
                print(result)
                complete(true, result)
            }
            else{
                self.result = result
                print(result)
                complete(false, result)
            }
        }
    }
    
    func getTasks(olympicsId: Int, complete: @escaping (_ success: Bool, _ resposnse: [Task]) -> Void){
        state = .loading
        let token = UserDefaults.standard.string(forKey: "token")!
        olympicsService.getTasks(olympicsId: olympicsId, token: token){
            success, tasks in
            if(success){
                self.selectedTasks = tasks
                print(self.selectedTasks)
                self.state = .ready
                complete(true, tasks)
            }
            else{
                self.state = .ready
                complete(false, tasks)
            }
        }
    }
}
