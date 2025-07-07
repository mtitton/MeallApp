//
//  RestaurantViewModelTests.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//

import XCTest
@testable import MeallApp

final class RestaurantViewModelTests: XCTestCase {

    func testFetchRestaurantsLoadsCorrectData() {
        // Given
        let viewModel = RestaurantViewModel(service: MockRestaurantService())
        let expectation = XCTestExpectation(description: "Fetch restaurants")

        // When
        viewModel.fetchRestaurants()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(viewModel.restaurants.count, 2)
            XCTAssertEqual(viewModel.restaurants.first?.restaurant, "Taco Town")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
