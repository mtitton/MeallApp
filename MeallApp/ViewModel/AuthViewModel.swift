//
//  AuthViewModel.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: UserModel?
    @Published var isError: Bool = false
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    init() {
        self.userSession = auth.currentUser
        Task {
            await loadCurrentUser()
        }
    }
    
    func loadCurrentUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: Nenhum usuário logado no Firebase Auth")
            return
        }

        print("DEBUG: UID do usuário logado: \(uid)")
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()

            self.currentUser = try snapshot.data(as: UserModel.self)
            print("DEBUG: Usuário carregado: \(self.currentUser?.fullName ?? "")")

        } catch {
            print("Erro ao carregar usuário: \(error.localizedDescription)")
        }
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
            } else {
                self.userSession = result?.user
                Task {
                    await self.fetchUser(by: result?.user.uid ?? "")
                    completion(nil)
                }
            }
        }
    }
    
    func createUser(email: String, fullName: String, password: String) async {
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            
            await storeUserInFirestore(uid: authResult.user.uid, email: email, fullName: fullName)
        } catch {
            isError = true
        }
    }
    
    func storeUserInFirestore(uid: String, email: String, fullName: String) async {
        let user = UserModel(uid: uid, email: email, fullName: fullName)
        do {
            try firestore.collection("users").document(uid).setData(from: user)
        } catch {
            isError = true
        }
    }
    
    func fetchUser(by uid: String) async {
        do {
            let document = try await firestore.collection("users").document(uid).getDocument()
            currentUser = try document.data(as: UserModel.self)
        } catch {
            isError = true
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
                self.userSession = nil
            }
        } catch {
            print("Erro ao deslogar: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        do {
            userSession = nil
            currentUser = nil
            deleteUser(by: auth.currentUser?.uid ?? "")
            try await auth.currentUser?.delete()
        } catch {
            isError = true
        }
    }
    
    private func deleteUser(by uid: String) {
        firestore.collection("users").document(uid).delete()
    }
    
    func resetPassword(by email: String) async {
        do {
            try await auth.sendPasswordReset(withEmail: email)
        } catch {
            isError = true
        }
    }
}
