//
//  MeallAppApp.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import SwiftUI
import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MeallAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var router = Router()
    @StateObject private var filterViewModel = FilterViewModel()
    @StateObject private var feedbackViewModel = FeedbackViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView()
                    .navigationDestination(for: Router.AuthFlow.self) { destination in
                        switch destination {
                            case .login: LoginView()
                            case .createAccount: CreateAccountView()
                            case .forgotPassword: ForgotPasswordView()
                            case .emailSent: EmailSentView()
                            case .home: HomeView().environmentObject(router)
                            case .profile: ProfileView()
                            case .cart: CartView()
                        }
                    }
            }
            .environmentObject(authViewModel)
            .environmentObject(router)
            .environmentObject(cartViewModel)
            .environmentObject(filterViewModel)
            .environmentObject(feedbackViewModel)
        }
    }
}
