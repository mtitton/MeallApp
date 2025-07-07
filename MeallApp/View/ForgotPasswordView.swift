//
//  ForgotPasswordView.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

// AINDA EM DESENVOLVIMENTO - NÃO ESTÁ ENVIANDO E-MAIL

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Esqueci a Senha")
                    .font(.largeTitle)
                
                Text("Coloque o seu e-mail para receber as instruções de redefinição de senha.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }.padding(.bottom, 32)
            
            InputView(placeholder: "E-mail", text: $email)
                .padding(.bottom, 16)
                .textInputAutocapitalization(.never)
            
            Button {
                Task {
                    await authViewModel.resetPassword(by: email)
                    if !authViewModel.isError {
                        router.navigate(to: .emailSent)
                    }
                }
            } label: {
                Text("Enviar Instruções")
            }
            .buttonStyle(CapsuleButtonStyle())

            
            Spacer()
        }
        .padding()
        .toolbarRole(.editor)
        .onAppear {
            email = ""
        }
    }
}

#Preview {
    ForgotPasswordView()
}
