//
//  RouterTests.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//

import XCTest
import SwiftUI // Importar SwiftUI para ter acesso a NavigationPath
@testable import MeallApp

final class RouterTests: XCTestCase {

    var sut: Router!

    override func setUpWithError() throws {
        sut = Router()
    }

    // MARK: - Testes de navigate(to:)

    func testNavigateToLoginShouldUpdateRouteStackAndNotCurrentTab() {
        // Given
        let initialRouteStackCount = sut.routeStack.count
        let initialTab = sut.currentTab

        // When
        sut.navigate(to: .login)

        // Then
        XCTAssertEqual(sut.routeStack.count, initialRouteStackCount + 1, "routeStack should have one more element")
        XCTAssertEqual(sut.routeStack.last, .login, "routeStack should contain the login destination as the last item")
        XCTAssertEqual(sut.currentTab, initialTab, "currentTab should not change for non-tab routes")
        XCTAssertEqual(sut.navPath.count, initialRouteStackCount + 1, "navPath count should match routeStack count")
    }

    func testNavigateToHomeShouldUpdateRouteStackAndCurrentTabToHome() {
        // Given
        sut.currentTab = "cart2"
        sut.navigate(to: .profile)

        // When
        sut.navigate(to: .home)

        // Then
        XCTAssertEqual(sut.routeStack.last, .home, "routeStack should contain the home destination as the last item")
        XCTAssertEqual(sut.currentTab, "home2", "currentTab should be updated to home2")
        XCTAssertEqual(sut.navPath.count, 2, "navPath should have 2 elements")
    }

    func testNavigateToCartShouldUpdateRouteStackAndCurrentTabToCart() {
        // Given
        sut.currentTab = "home2"
        sut.navigate(to: .profile)

        // When
        sut.navigate(to: .cart)

        // Then
        XCTAssertEqual(sut.routeStack.last, .cart, "routeStack should contain the cart destination as the last item")
        XCTAssertEqual(sut.currentTab, "cart2", "currentTab should be updated to cart2")
        XCTAssertEqual(sut.navPath.count, 2, "navPath should have 2 elements")
    }

    func testNavigateToMultipleDestinationsShouldStackCorrectly() {
        // When
        sut.navigate(to: .home)
        sut.navigate(to: .profile)
        sut.navigate(to: .cart)

        // Then
        XCTAssertEqual(sut.routeStack.count, 3, "routeStack should have 3 elements")
        XCTAssertEqual(sut.routeStack[0], .home)
        XCTAssertEqual(sut.routeStack[1], .profile)
        XCTAssertEqual(sut.routeStack[2], .cart)
        XCTAssertEqual(sut.currentTab, "cart2", "currentTab should reflect the last tab route")
        XCTAssertEqual(sut.navPath.count, 3, "navPath count should match routeStack count")
    }

    // MARK: - Testes de navigateBack()

    func testNavigateBackWithOneItemShouldClearRouteStackAndNavPathAndResetCurrentTab() {
        // Given
        sut.navigate(to: .profile)

        // When
        sut.navigateBack()

        // Then
        XCTAssertTrue(sut.routeStack.isEmpty, "routeStack should be empty after navigating back from a single item")
        XCTAssertTrue(sut.navPath.isEmpty, "navPath should be empty after navigating back from a single item")
        XCTAssertEqual(sut.currentTab, "home2", "currentTab should reset to home2 when stack is empty")
    }

    func testNavigateBackWithMultipleItemsShouldRemoveLastItemAndUpdateCurrentTab() {
        // Given
        sut.navigate(to: .home)
        sut.navigate(to: .profile)
        sut.navigate(to: .cart)

        // When
        sut.navigateBack()

        // Then
        XCTAssertEqual(sut.routeStack.count, 2, "routeStack should have 2 elements")
        XCTAssertEqual(sut.routeStack.last, .profile, "The last item in routeStack should be profile")
        XCTAssertEqual(sut.navPath.count, 2, "navPath should have 2 elements")
    }
    
    func testNavigateBackFromHomeShouldKeepHomeAsCurrentTab() {
        // Given
        sut.navigate(to: .home)
        XCTAssertEqual(sut.routeStack.count, 1)
        XCTAssertEqual(sut.navPath.count, 1)
        XCTAssertEqual(sut.currentTab, "home2")

        // When
        sut.navigateBack()

        // Then
        XCTAssertTrue(sut.routeStack.isEmpty, "routeStack should be empty as home was the only item")
        XCTAssertTrue(sut.navPath.isEmpty, "navPath should be empty")
        XCTAssertEqual(sut.currentTab, "home2", "currentTab should remain home2 when navigating back from an empty stack (or root)")
    }

    // MARK: - Testes de navigateToRoot()

    func testNavigateToRootShouldClearAllPathsAndSetCurrentTabToHome() {
        // Given
        sut.navigate(to: .login)
        sut.navigate(to: .home)
        sut.navigate(to: .profile)
        sut.navigate(to: .cart)
        sut.currentTab = "cart2"

        // When
        sut.navigateToRoot()

        // Then
        XCTAssertTrue(sut.navPath.isEmpty, "navPath should be empty after navigating to root")
        XCTAssertTrue(sut.routeStack.isEmpty, "routeStack should be empty after navigating to root")
        XCTAssertEqual(sut.currentTab, "home2", "currentTab should be home2 after navigating to root")
    }
}
