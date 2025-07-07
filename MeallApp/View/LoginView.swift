//
//  LoginView.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var feedbackViewModel: FeedbackViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 5) {
                    logo
                    
                    titleView
                    
                    Spacer().frame(height: 20)
                    
                    InputView(
                        placeholder: "E-mail",
                        text: $email
                    ).textInputAutocapitalization(.never)
                    
                    InputView(
                        placeholder: "Senha",
                        isSecureField: true,
                        text: $password
                    ).textInputAutocapitalization(.never)
                    
                    forgotButton
                    
                    Spacer()
                    
                    loginButton
                    
                    Spacer()
                    
                    bottomView
                }
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
        .ignoresSafeArea()
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var logo: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
    }
    
    private var titleView: some View {
        Text("Bem vindo ao Meall")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    private var forgotButton: some View {
        HStack {
            Spacer()
            Button {
                router.navigate(to: .forgotPassword)
            } label: {
                Text("Esqueci minha senha")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
    
    private var loginButton: some View {
        Button {
            authViewModel.login(withEmail: email, password: password) { error in
                if let error = error {
                    print("Erro de login: \(error.localizedDescription)")
                    feedbackViewModel.show(message: "Não foi possível autenticar. Verifique seus dados e tente novamente.", isError: true)
                }
            }
        } label: {
            Text("Login")
        }
        .buttonStyle(CapsuleButtonStyle())
    }
    
    private var line: some View {
        VStack { Divider().frame(height: 1) }
    }
    
    private var bottomView: some View {
        VStack(spacing: 16) {
            lineorView
            footerView
        }
    }
    
    private var lineorView: some View {
        HStack(spacing: 16) {
            line
            Text("ou")
                .fontWeight(.semibold)
            line
        }
        .foregroundStyle(.gray)
    }
    
    private var footerView: some View {
        Button {
            router.navigate(to: .createAccount)
        } label: {
            HStack {
                Text("Não tem uma conta?")
                    .foregroundStyle(.black)
                Text("Cadastre-se")
                    .foregroundStyle(.teal)
            }
            .fontWeight(.medium)
        }
    }
}

struct CapsuleButtonStyle: ButtonStyle {
    var bgColor: Color = .teal
    var textColor: Color = .white
    var hasBorder: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(bgColor))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .overlay {
                hasBorder ?
                Capsule()
                    .stroke(.gray, lineWidth: 1) :
                nil
            }
    }
}

struct InputView: View {
    let placeholder: String
    var isSecureField: Bool = false
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 12) {
            if isSecureField {
                SecureField(placeholder, text: $text)
            }else {
                TextField(placeholder, text: $text)
            }
            
            Divider()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
