//
//  CartViewModelTests.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//

import XCTest
@testable import MeallApp

final class CartViewModelTests: XCTestCase {

    var sut: CartViewModel!
    
    let food1 = Food(id: "1", name: "Pizza", restaurant: "Pizzaria", subtitle: "Mussarela", price: 30.0, imagePath: "", description: "")
    let food2 = Food(id: "2", name: "Hamburguer", restaurant: "Lanchonete", subtitle: "X-Bacon", price: 25.0, imagePath: "", description: "")
    let food3 = Food(id: "3", name: "Suco", restaurant: "Lanchonete", subtitle: "Laranja", price: 10.0, imagePath: "", description: "")

    override func setUpWithError() throws {
        sut = CartViewModel()
    }
    
    // MARK: - Testes de addToCart(_:quantity:)

    func testAddToCartShouldAddItemWhenCartIsEmpty() {
        // When
        sut.addToCart(food1, quantity: 2)

        // Then
        XCTAssertEqual(sut.items.count, 1, "Cart should contain one item")
        XCTAssertEqual(sut.items.first?.food.id, food1.id, "The added food should be food1")
        XCTAssertEqual(sut.items.first?.quantity, 2, "Quantity should be 2")
    }

    func testAddToCartShouldIncrementQuantityWhenItemAlreadyExists() {
        // Given
        sut.addToCart(food1, quantity: 1)

        // When
        sut.addToCart(food1, quantity: 2)

        // Then
        XCTAssertEqual(sut.items.count, 1, "Cart should still contain only one unique item")
        XCTAssertEqual(sut.items.first?.food.id, food1.id, "The food should still be food1")
        XCTAssertEqual(sut.items.first?.quantity, 3, "Quantity should be incremented to 3")
    }

    func testAddToCartShouldAddSeparateItemWhenDifferentFoodAdded() {
        // Given
        sut.addToCart(food1, quantity: 1)

        // When
        sut.addToCart(food2, quantity: 1)

        // Then
        XCTAssertEqual(sut.items.count, 2, "Cart should contain two distinct items")
        XCTAssertTrue(sut.items.contains(where: { $0.food.id == food1.id && $0.quantity == 1 }))
        XCTAssertTrue(sut.items.contains(where: { $0.food.id == food2.id && $0.quantity == 1 }))
    }

    // MARK: - Testes de removeFromCart(_:)

    func testRemoveFromCartShouldRemoveExistingItem() {
        // Given
        sut.addToCart(food1, quantity: 1)
        sut.addToCart(food2, quantity: 2)
        let itemToRemove = sut.items.first(where: { $0.food.id == food1.id })!

        // When
        sut.removeFromCart(itemToRemove)

        // Then
        XCTAssertEqual(sut.items.count, 1, "Cart should contain one item after removal")
        XCTAssertFalse(sut.items.contains(where: { $0.food.id == food1.id }), "Food1 should be removed")
        XCTAssertTrue(sut.items.contains(where: { $0.food.id == food2.id }), "Food2 should still be in cart")
    }

    func testRemoveFromCartShouldDoNothingWhenItemDoesNotExist() {
        // Given
        sut.addToCart(food1, quantity: 1)
        let nonExistentItem = CartItemModel(food: food3, quantity: 1)

        // When
        sut.removeFromCart(nonExistentItem)

        // Then
        XCTAssertEqual(sut.items.count, 1, "Cart count should remain unchanged")
        XCTAssertTrue(sut.items.contains(where: { $0.food.id == food1.id }), "Food1 should still be in cart")
    }

    // MARK: - Testes de clearCart()

    func testClearCartShouldRemoveAllItems() {
        // Given
        sut.addToCart(food1, quantity: 1)
        sut.addToCart(food2, quantity: 2)

        // When
        sut.clearCart()

        // Then
        XCTAssertTrue(sut.items.isEmpty, "Cart should be empty after clearing")
    }

    // MARK: - Testes de total

    func testTotalShouldCalculateCorrectSum() {
        // Given
        sut.addToCart(food1, quantity: 2) // 30.0 * 2 = 60.0
        sut.addToCart(food2, quantity: 1) // 25.0 * 1 = 25.0

        // Then
        XCTAssertEqual(sut.total, 85.0, "Total should be calculated correctly")
    }

    func testTotalShouldBeZeroWhenCartIsEmpty() {
        // Then
        XCTAssertEqual(sut.total, 0.0, "Total should be 0 when cart is empty")
    }

    // MARK: - Testes de decreaseQuantity(for:)

    func testDecreaseQuantityShouldDecrementQuantity() {
        // Given
        sut.addToCart(food1, quantity: 3)

        // When
        sut.decreaseQuantity(for: food1)

        // Then
        XCTAssertEqual(sut.items.count, 1)
        XCTAssertEqual(sut.items.first?.quantity, 2, "Quantity should be decremented to 2")
    }

    func testDecreaseQuantityShouldRemoveItemWhenQuantityReachesZero() {
        // Given
        sut.addToCart(food1, quantity: 1)

        // When
        sut.decreaseQuantity(for: food1)

        // Then
        XCTAssertTrue(sut.items.isEmpty, "Item should be removed when quantity reaches 0")
    }

    func testDecreaseQuantityShouldDoNothingWhenFoodNotInCart() {
        // Given
        sut.addToCart(food1, quantity: 1)

        // When
        sut.decreaseQuantity(for: food2)

        // Then
        XCTAssertEqual(sut.items.count, 1, "Cart count should remain unchanged")
        XCTAssertEqual(sut.items.first?.quantity, 1, "Quantity of food1 should remain 1")
    }
}
