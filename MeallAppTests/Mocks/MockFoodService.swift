//
//  MockFoodService.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//

@testable import MeallApp

class MockFoodService: FoodFetchingService {
    var mockFoods: [Food]

    init(mockFoods: [Food]) {
        self.mockFoods = mockFoods
    }

    func fetchFoods(completion: @escaping ([Food]) -> Void) {
        completion(mockFoods)
    }
}
