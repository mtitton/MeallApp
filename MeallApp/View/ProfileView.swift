//
//  ProfileView.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        Group {
            if let user = authViewModel.currentUser {
                List {
                    Section {
                        HStack(spacing: 16) {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 70, height: 70)
                                .background(Color(.lightGray))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(user.email)
                                    .font(.footnote)
                            }
                        }
                    }
                    
                    Section("Conta") {
                        Button {
                            authViewModel.signOut()
                            router.navigateToRoot()
                        } label: {
                            Label("Sair", systemImage: "arrow.left.circle.fill")
                                .foregroundStyle(.black)
                        }
                        
                        Button {
                            Task {
                                await authViewModel.deleteAccount()
                                router.navigateToRoot()
                            }
                        } label: {
                            Label {
                                Text("Deletar Conta")
                                    .foregroundStyle(.red)
                            } icon: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }

                    }
                }
            } else {
                ProgressView("Carregando...")
            }
        }
        .onAppear {
            print("onAppear ProfileView")

            if authViewModel.currentUser == nil {
                print("currentUser está nil. Tentando carregar...")
                Task {
                    await authViewModel.loadCurrentUser()
                }
            } else {
                print("Usuário já carregado: \(authViewModel.currentUser?.fullName ?? "")")
            }
        }
    }
}

#Preview {
    ProfileView()
}
