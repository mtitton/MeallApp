//
//  CreateAccountView.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import SwiftUI

struct CreateAccountView: View {
    
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var feedbackViewModel: FeedbackViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("Complete as informações para criar uma conta.")
                    .font(.headline).fontWeight(.medium)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                InputView(
                    placeholder: "E-mail",
                    text: $email
                ).textInputAutocapitalization(.never)
                
                InputView(
                    placeholder: "Nome Completo",
                    text: $fullName
                )
                
                InputView(
                    placeholder: "Senha",
                    isSecureField: true,
                    text: $password
                ).textInputAutocapitalization(.never)
                
                ZStack(alignment: .trailing) {
                    InputView(
                        placeholder: "Confirme a senha",
                        isSecureField: true,
                        text: $confirmPassword
                    ).textInputAutocapitalization(.never)
                    
                    Spacer()
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        Image(systemName: "\(isValidPassword ? "checkmark" : "xmark").circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword ? Color(.systemGreen) : Color(.systemRed))
                    }
                }
                
                Spacer()
                
                Button {
                    Task {
                        guard !email.isEmpty, !fullName.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                            feedbackViewModel.show(message: "Preencha todos os campos.", isError: true)
                            return
                        }
                        
                        guard isValidPassword else {
                            feedbackViewModel.show(message: "As senhas não coincidem.", isError: true)
                            return
                        }
                        
                        await authViewModel.createUser(
                            email: email,
                            fullName: fullName,
                            password: password
                        )
                        
                        if authViewModel.isError {
                            feedbackViewModel.show(message: "Não foi possível criar a conta. Verifique os dados e tente novamente.", isError: true)
                        } else {
                            feedbackViewModel.show(message: "Conta criada com sucesso!", isError: false)
                            router.navigateBack()
                        }
                    }
                } label: {
                    Text("Criar conta")
                }
                .buttonStyle(CapsuleButtonStyle())
            }
            
            if feedbackViewModel.isVisible {
                VStack {
                    Spacer()
                    ToastView(message: feedbackViewModel.message, isError: feedbackViewModel.isError)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: feedbackViewModel.isVisible)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Crie sua conta")
        .toolbarRole(.editor)
        .padding()
    }
    
    var isValidPassword: Bool {
        confirmPassword == password
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(AuthViewModel())
}
