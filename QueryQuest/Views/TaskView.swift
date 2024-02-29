//
//  TaskView.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 12.12.23.
//

import SwiftUI

struct TaskView: View {
    
    let task: Task
    let taskOrder: Int
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    LabeledContent("ID задания", value: "\(task.id)")
                    LabeledContent("ID олимпидаы", value: "\(task.olympicsId)")
                } header: {
                    Text("Информация")
                }
                Section{
                    Text(task.title)
                } header: {
                    Text("Задание")
                }
            }
            .navigationTitle(Text("Задание №\(taskOrder)"))
        }
    }
}

#Preview {
    TaskView(task: Task(id: 1, olympicsId: 1001, title: "Example Task", solution: "Example Solution", image: "example_image"), taskOrder: 1)
}
