//
//  OlympicsView.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 2.12.23.
//

import SwiftUI

struct OlympicsView: View {
    
    @ObservedObject var viewModel = OlympicsViewModel()
    @State var viewTasks : [Task] = []
    @State var viewResult : Result = Result(totalScore: -1, maxTime: Date.now, userId: -1, place: -1)
    let olympics: Olympics
    let path: String
    
    var body: some View {
        NavigationStack{
            switch viewModel.state{
            case .loading:
                Form{
                    Section{
                        Text(olympics.description)
                        LabeledContent("Начало", value: olympics.startTime.formatted())
                        LabeledContent("Завершение", value: olympics.endTime.formatted())
                    } header: {
                        Text("Олимпиада")
                    }
                    Section{
                        Text("\(olympics.creator.name) \(olympics.creator.surname)")
                        LabeledContent("Email", value: olympics.creator.email)
                    } header: {
                        Text("Организатор")
                    }
                    Section{
                        HStack(alignment: .top){
                            VStack{
                                Spacer()
                                ProgressView()
                                Text("Загрузка")
                                Spacer()
                            }
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .center)
                    }
                }
            case .ready:
                VStack{
                    Form{
                        Section{
                            HStack(alignment: .top){
                                VStack{
                                    AsyncImage(url: URL(string: olympics.image)) { image in
                                        image.resizable()
                                        image.scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 1000, height: 280)
                                }
                            }
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .center)
                        }
                        Section{
                            Text(olympics.description)
                            LabeledContent("Начало", value: olympics.startTime.formatted())
                            LabeledContent("Завершение", value: olympics.endTime.formatted())
                        } header: {
                            Text("Олимпиада")
                        }
                        Section{
                            Text("\(olympics.creator.name) \(olympics.creator.surname)")
                            LabeledContent("E-mail", value: olympics.creator.email)
                        } header: {
                            Text("Организатор")
                        }
                        Section{
                            if(path == "planned"){
                                Text("Задания не доступны до начала олимпиады")
                            }
                            else if(path == "current"){
                                if(viewTasks.isEmpty){
                                    Text("Задания не найдены")
                                }
                                else{
                                    List{
                                        ForEach(Array(viewTasks.enumerated()), id: \.1.id) { index, task in
                                            NavigationLink("Задание №\(index + 1)", destination: TaskView(task: task, taskOrder: index + 1))
                                        }

                                    }
                                }
                            }
                            else if(path == "finished"){
                                Text("Задания не доступны после завершения олимпиады")
                            }
                            
                        } header: {
                            Text("Задания")
                        }
                        if(viewResult.place != -1){
                            if(path == "finished"){
                                Section{
                                    LabeledContent("Место", value: String(viewResult.place))
                                    LabeledContent("Всего баллов", value: String(viewResult.totalScore))
                                    LabeledContent("Время последнего ответа", value: String(viewResult.maxTime.formatted()))
                                } header: {
                                    Text("Результаты")
                                }
                            }
                            else if(path == "current"){
                                Section{
                                    LabeledContent("Место", value: String(viewResult.place))
                                    LabeledContent("Всего баллов", value: String(viewResult.totalScore))
                                    LabeledContent("Время последнего ответа", value: String(viewResult.maxTime.formatted()))
                                } header: {
                                    Text("Промежуточные результаты")
                                }
                            }
                        }
                    }
                }
                .navigationTitle(olympics.name)
            }
        }
        .onAppear{
            viewModel.getTasks(olympicsId: olympics.id){
                success, tasks in
                viewTasks = tasks
            }
            viewModel.getResult(olympicsId: olympics.id){
                success, result in
                viewResult = result
            }
        }
    }
}

//#Preview {
//    OlympicsView(olympics: Olympics(
//        id: 1,
//        creatorId: 1,
//        name: "Sample Olympics",
//        startTime: Date(),
//        endTime: Date(),
//        description: "This is a sample Olympics event. his is a sample Olympics event. his is a sample Olympics event. his is a sample Olympics event.",
//        databaseName: "SampleDB",
//        databaseScript: "CREATE TABLE ...",
//        image: "sample_image_url",
//        creator: Creator(
//            id: 1,
//            email: "sample@example.com",
//            password: "password",
//            surname: "Doe",
//            name: "John",
//            phone: "123456789",
//            course: "Computer Science",
//            group: "A1",
//            roleId: 2
//        )
//    ), path: "current")
//}
