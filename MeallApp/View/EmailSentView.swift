//
//  EmailSentView.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

// AINDA EM DESENVOLVIMENTO - NÃO ESTÁ ENVIANDO E-MAIL

import SwiftUI

struct EmailSentView: View {
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "envelope.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.teal)
            
            VStack(spacing: 8) {
                Text("Verifique seu e-mail.")
                    .font(.largeTitle.bold())
                
                Text("Nós enviamos um e-mail para confirmar seu e-mail. Clique no link no e-mail para continuar.")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                router.navigateToRoot()
            } label: {
                Text("Vou confirmar depois.")
            }
            .buttonStyle(CapsuleButtonStyle())

            Spacer()
            
            Button {
                router.navigateBack()
            } label: {
                (Text("Não recebeu o e-mail? Verifique se o e-mail está na caixa de spam. Ou")
                    .foregroundColor(.gray)
                +
                 Text("tente um novo email.")
                    .foregroundColor(.teal))
            }
        }
        .padding()
        .toolbarRole(.editor)
    }
}

#Preview {
    EmailSentView()
}
