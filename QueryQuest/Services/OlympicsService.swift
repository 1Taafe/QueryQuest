//
//  OlympicsService.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 28.11.23.
//

import Foundation
import Alamofire
import SwiftyJSON

class OlympicsService{
    
    let formatter = ISO8601DateFormatter()
    
    func getResult(olympicsId: Int, token: String, complete: @escaping (_ success: Bool, _ response: Result) -> Void){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
        ]
        
        AF.request("\(Service.url)/olympics/\(olympicsId)/results", method: .get, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                    case .success(let value):
                    if(value != nil){
                        let json = JSON(value!)
                        
                        let totalScore = json["_sum"]["score"].intValue
                        let maxTimeString = json["_max"]["time"].stringValue
                        
                        self.formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                        
                        if let maxTime = self.formatter.date(from: maxTimeString) {
                            let userId = json["userId"].intValue
                            let place = json["place"].intValue
                            
                            let userScore = Result(totalScore: totalScore, maxTime: maxTime, userId: userId, place: place)
                            complete(true, userScore)
                        }
                        else {
                            complete(false, Result(totalScore: -1, maxTime: Date.now, userId: -1, place: -1))
                        }
                    }
                    else{
                        complete(false, Result(totalScore: -1, maxTime: Date.now, userId: -1, place: -1))
                    }
                    case .failure(let error):
                        print(error)
                        complete(false, Result(totalScore: -1, maxTime: Date.now, userId: -1, place: -1))
                }
        }
    }
    
    func getTasks(olympicsId: Int, token: String, complete: @escaping (_ success: Bool, _ resposnse: [Task]) -> Void){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
        ]
        
        AF.request("\(Service.url)/olympics/\(olympicsId)/tasks", method: .get, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value!)
                    if let tasksArray = json.array {
                        let tasks = tasksArray.map { taskData in
                            return Task(
                                id: taskData["id"].intValue,
                                olympicsId: taskData["olympicsId"].intValue,
                                title: taskData["title"].stringValue,
                                solution: taskData["solution"].stringValue
                            )
                        }
                        complete(true, tasks)
                    }
                case .failure(let error):
                    print(error)
                    complete(false, [])
                }
        }
    }
    
    func getOlympics(path: String, token: String, complete: @escaping (_ success: Bool, _ response: [Olympics]) -> Void){

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
        ]
        
        AF.request("\(Service.url)/olympics/\(path)", method: .get, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value!)
                    if let eventsArray = json.array {
                        self.formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                        let events = eventsArray.map { eventData in
                            return Olympics(
                                id: eventData["id"].intValue,
                                creatorId: eventData["creatorId"].intValue,
                                name: eventData["name"].stringValue,
                                startTime: self.formatter.date(from: eventData["startTime"].stringValue) ?? Date(),
                                endTime: self.formatter.date(from: eventData["endTime"].stringValue) ??  Date(),
                                description: eventData["description"].stringValue,
                                databaseName: eventData["databaseName"].stringValue,
                                databaseScript: eventData["databaseScript"].stringValue,
                                image: eventData["image"].stringValue,
                                creator: Creator(
                                    id: eventData["creator"]["id"].intValue,
                                    email: eventData["creator"]["email"].stringValue,
                                    password: eventData["creator"]["password"].stringValue,
                                    surname: eventData["creator"]["surname"].stringValue,
                                    name: eventData["creator"]["name"].stringValue,
                                    phone: eventData["creator"]["phone"].stringValue,
                                    course: eventData["creator"]["course"].stringValue,
                                    group: eventData["creator"]["group"].stringValue,
                                    roleId: eventData["creator"]["roleId"].intValue
                                )
                            )
                        }
                        complete(true, events)
                    }
                case .failure(let error):
                    print(error)
                    complete(false, [])
                }
        }
    }
    
}
