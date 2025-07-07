//
//  MockRestaurantService.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//

@testable import MeallApp

class MockRestaurantService: RestaurantFetchingService {
    
    func fetchRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        let mockData = [
            Restaurant(id: "1", restaurant: "Taco Town", imagePath: "taco"),
            Restaurant(id: "2", restaurant: "Sushi Spot", imagePath: "sushi")
        ]
        completion(mockData)
    }
    
}
