//
//  RestaurantViewModel.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import Foundation
import FirebaseFirestore

class RestaurantViewModel: ObservableObject {

    @Published var restaurants: [Restaurant] = []

    private let service: RestaurantFetchingService

    init(service: RestaurantFetchingService = FirestoreRestaurantService()) {
        self.service = service
    }

    func fetchRestaurants() {
        service.fetchRestaurants { [weak self] restaurants in
            DispatchQueue.main.async {
                self?.restaurants = restaurants
            }
        }
    }
}

