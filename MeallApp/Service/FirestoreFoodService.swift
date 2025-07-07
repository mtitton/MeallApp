//
//  FirestoreFoodService.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//

import FirebaseFirestore

protocol FoodFetchingService {
    func fetchFoods(completion: @escaping ([Food]) -> Void)
}

class FirestoreFoodService: FoodFetchingService {
    private let db = Firestore.firestore()

    func fetchFoods(completion: @escaping ([Food]) -> Void) {
        db.collection("foods").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Erro ao buscar comidas: \(error?.localizedDescription ?? "desconhecido")")
                completion([])
                return
            }

            let foods = documents.compactMap { try? $0.data(as: Food.self) }
            completion(foods)
        }
    }
}
