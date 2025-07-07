//
//  FirestoreRestaurantService.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//

import FirebaseFirestore

protocol RestaurantFetchingService {
    func fetchRestaurants(completion: @escaping ([Restaurant]) -> Void)
}

class FirestoreRestaurantService: RestaurantFetchingService {
    private let db = Firestore.firestore()

    func fetchRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        db.collection("restaurants").getDocuments { snapshot, error in
            if let error = error {
                print("Erro ao buscar restaurantes: \(error)")
                completion([])
                return
            }

            let restaurants = snapshot?.documents.compactMap { doc -> Restaurant? in
                try? doc.data(as: Restaurant.self)
            } ?? []

            completion(restaurants)
        }
    }
}
