//
//  Router.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import SwiftUI

final class Router: ObservableObject {
    
    @Published var navPath = NavigationPath()
    @Published var currentTab: String = "home2"
    var routeStack: [AuthFlow] = []
    
    enum AuthFlow: Hashable, Codable {
        case login
        case createAccount
        case forgotPassword
        case emailSent
        case home
        case profile
        case cart
    }
    
    func navigate(to destination: AuthFlow) {
        navPath.append(destination)
        routeStack.append(destination)

        // Atualiza a tab se for uma rota com tab
        switch destination {
        case .home:
            currentTab = "home2"
        case .cart:
            currentTab = "cart2"
        default:
            break
        }
    }

    func navigateBack() {
        if !routeStack.isEmpty {
            routeStack.removeLast()
        }
        if !navPath.isEmpty {
            navPath.removeLast()
        }

        if let last = routeStack.last {
            switch last {
            case .home:
                currentTab = "home2"
            case .cart:
                currentTab = "cart2"
            default:
                break
            }
        } else {
            // Pilha vazia = provavelmente está na home
            currentTab = "home2"
        }
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
        routeStack.removeAll()
        currentTab = "home2"
    }
}
