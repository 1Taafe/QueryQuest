//
//  Olympics.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 28.11.23.
//

import Foundation

struct Olympics{
    var id: Int
    var creatorId: Int
    var name: String
    var startTime: Date
    var endTime: Date
    var description: String
    var databaseName: String
    var databaseScript: String
    var image: String
    var creator: Creator
}
