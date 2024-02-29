//
//  LoginView.swift
//  QueryQuest
//
//  Created by Дмитрий Заянковский on 11.11.23.
//

import SwiftUI
import CodeScanner

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    @State private var isNavigated = false
    @State private var isErrorShown = false
    @State private var isQrSheetShown = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack{
            switch viewModel.state{
            case .loading:
                VStack{
                    ProgressView()
                    Text("Загрузка")
                }
            case .ready:
                VStack{
                    Spacer()
                    Image("fit_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                    Text("Query Quest – олимпиады по\n базам данных")
                        .multilineTextAlignment(.center)
                    Spacer()
                }.padding()
                Form{
                    Section{
                        HStack{
                            Image(systemName: "at")
                            TextField("Адрес электронной почты", text: $viewModel.currentUser.email)
                        }
                        HStack{
                            Image(systemName: "lock")
                            SecureField("Пароль", text: $viewModel.currentUser.password)
                        }
                    }
                    Section{
                        Button(action: {
                            viewModel.login(){
                                success, response in
                                if(success){
                                    isNavigated = true
                                }
                                else{
                                    errorMessage = response["message"].stringValue
                                    isErrorShown = true
                                }
                            }
                        }) {
                            Text("Войти")
                        }
                        .cornerRadius(8)
                        .navigationDestination(isPresented: $isNavigated){
                            HomeView()
                        }
                        Button(action: {
                            isQrSheetShown.toggle()
                        }) {
                            HStack{
                                Image(systemName: "qrcode")
                                Text("Войти с помощью QR")
                            }
                        }
                    }
                }
                .alert("Произошла ошибка", isPresented: $isErrorShown, actions: {
                    Button("Закрыть"){
                        isErrorShown = false
                    }
                    }, message: {
                        Text(errorMessage)
                    })
                .sheet(isPresented: $isQrSheetShown){
                    CodeScannerView(codeTypes: [.qr]) {
                        response in
                        if case let .success(result) = response {
                            let scannedCode = result.string
                            viewModel.loginByQr(token: scannedCode){
                                success, response in
                                if(success){
                                    isNavigated = true
                                }
                                else{
                                    errorMessage = "Не удалось распознать QR код"
                                    isErrorShown = true
                                }
                            }
                            isQrSheetShown = false
                        }
                    }
                }
            case .failed:
                VStack{
                    Text("Ошибка")
                    
                }
            }
        }
        .onAppear{
            viewModel.loginWithToken{
                success, response in
                if(success){
                    isNavigated = true
                }
                else{
//                    errorMessage = response["message"].stringValue
//                    isErrorShown = true
                }
            }
        }
    }
}


#Preview {
    LoginView(viewModel: LoginViewModel(authService: AuthService()))
}
