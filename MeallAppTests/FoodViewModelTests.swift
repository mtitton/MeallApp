//
//  FoodViewModelTests.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//

import XCTest
@testable import MeallApp

final class FoodViewModelTests: XCTestCase {

    var sut: FoodViewModel!
    var mockFoods: [Food]!

    override func setUp() {
        super.setUp()
        mockFoods = [
            Food(id: "1", name: "Burger", restaurant: "Burger House", subtitle: "", price: 19.99, imagePath: "", description: ""),
            Food(id: "2", name: "Pizza", restaurant: "Pizza Place", subtitle: "", price: 29.99, imagePath: "", description: ""),
            Food(id: "3", name: "Cheese Burger", restaurant: "Burger House", subtitle: "", price: 24.99, imagePath: "", description: "")
        ]
        let mockService = MockFoodService(mockFoods: mockFoods)
        sut = FoodViewModel(foodService: mockService)
    }

    func testFetchAllFoods() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch foods")

        // When
        sut.fetchFoods()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.sut.allFoods.count, 3)
            XCTAssertEqual(self.sut.filteredFoods.count, 3)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFilterFoodsByRestaurant() {
        // Given
        let expectation = XCTestExpectation(description: "Filter foods")

        // When
        sut.fetchFoods(filteredBy: "Burger House")

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.sut.filteredFoods.count, 2)
            XCTAssertTrue(self.sut.filteredFoods.allSatisfy { $0.restaurant == "Burger House" })
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
