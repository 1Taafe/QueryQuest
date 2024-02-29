//
//  HomeView.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 18.11.23.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel = HomeViewModel()
    @State private var isAccountSheetShown = false
    @State private var paths = ["Предстоящие", "Текущие", "Завершенные"]
    @State private var selectedPath = "Текущие"
    @State private var selectedRequestPath = "current"
    
    var body: some View {
        NavigationStack{
            switch viewModel.state{
            case .loading:
                VStack{
                    Picker("Olympics", selection: $selectedPath){
                        ForEach(paths, id: \.self){
                            Text($0)
                        }
                    }
                    .onChange(of: selectedPath){
                        if(selectedPath == paths[0]){
                            viewModel.getOlympics(path: "planned")
                        }
                        else if(selectedPath == paths[1]){
                            viewModel.getOlympics(path: "current")
                        }
                        else{
                            viewModel.getOlympics(path: "finished")
                        }
                        
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    Form{
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
                }
                .navigationTitle("Главная")
                .navigationBarTitleDisplayMode(.inline)
            case .ready:
                VStack{
                    Picker("Olympics", selection: $selectedPath){
                        ForEach(paths, id: \.self){
                            Text($0)
                        }
                    }
                    .onChange(of: selectedPath){
                        if(selectedPath == paths[0]){
                            viewModel.getOlympics(path: "planned")
                            selectedRequestPath = "planned"
                        }
                        else if(selectedPath == paths[1]){
                            viewModel.getOlympics(path: "current")
                            selectedRequestPath = "current"
                        }
                        else{
                            viewModel.getOlympics(path: "finished")
                            selectedRequestPath = "finished"
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    if(viewModel.selectedOlympics.isEmpty){
                        Form{
                            Text("Олимпиад не найдено")
                        }
                    }
                    else{
                        Form{
                            Section{
                                List{
                                    ForEach(viewModel.selectedOlympics, id: \.id){
                                        NavigationLink($0.name, destination: OlympicsView(olympics: $0, path: selectedRequestPath))
                                    }
                                }
                            } header: {
                                Text("Олимпиады")
                            }
                        }
                    }
                }
                .toolbar{
                    Button(action: {
                        isAccountSheetShown.toggle()
                    }){
                        Image(systemName: "person.crop.circle.fill")
                    }
                    
                }
                .sheet(isPresented: $isAccountSheetShown){
                    NavigationStack{
                        switch(viewModel.sheetState){
                        case .ready:
                            Form{
                                Section{
                                    HStack(alignment: .top){
                                        VStack{
                                            Spacer()
                                            Image(systemName: "person.crop.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxHeight: 64)
                                                .foregroundStyle(Color.secondary)
                                            Spacer()
                                            Text("\(viewModel.currentUser.name) \(viewModel.currentUser.surname)")
                                                .font(Font.title)
                                            Text(viewModel.currentUser.email)
                                                .font(Font.callout)
                                            Text("Участник")
                                                .font(Font.subheadline)
                                                .foregroundStyle(.secondary)
                                            Spacer()
                                        }
                                    }
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .center)
                                }
                                Section{
                                    LabeledContent("Курс", value: String(viewModel.currentUser.course))
                                    LabeledContent("Группа", value: String(viewModel.currentUser.group))
                                }
                                Section{
                                    Button(action: {
                                        isAccountSheetShown.toggle()
                                        viewModel.signOut()
                                        self.presentation.wrappedValue.dismiss()
                                    }){
                                        Text("Выйти")
                                            .foregroundStyle(Color.red)
                                    }
                                }
                            }
                            .navigationTitle("Профиль")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar{
                                Button(action: {
                                    isAccountSheetShown.toggle()
                                }){
                                    Text("Закрыть")
                                }
                            }
                        case .loading:
                            VStack{
                                ProgressView()
                                Text("Загрузка")
                            }
                            .navigationTitle("Профиль")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar{
                                Button(action: {
                                    isAccountSheetShown.toggle()
                                }){
                                    Text("Закрыть")
                                }
                            }
                        case .failed:
                            VStack{
                                Text("Ошибка")
                            }
                        }
                    }
                    .onAppear(){
                        viewModel.getUserInfo()
                    }
                }
                .navigationTitle("Главная")
                .navigationBarTitleDisplayMode(.inline)
            case .failed:
                VStack{
                    Text("Ошибка")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear{
            viewModel.getOlympics(path: "current")
        }
    }
}

//#Preview {
//    HomeView()
//}
