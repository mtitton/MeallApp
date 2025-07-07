//
//  ContentView.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else {
                HomeView()
            }
        }
        .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
}
