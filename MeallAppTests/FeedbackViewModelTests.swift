//
//  FeedbackViewModelTests.swift
//  MeallApp
//
//  Created by Marcus Titton on 07/07/25.
//
 
import XCTest
@testable import MeallApp

final class FeedbackViewModelTests: XCTestCase {

    var sut: FeedbackViewModel!

    override func setUpWithError() throws {
        sut = FeedbackViewModel()
    }

    func testShowShouldSetMessageIsVisibleAndIsErrorCorrectly() {
        // Given
        let testMessage = "Test message"
        let testIsError = true

        // When
        sut.show(message: testMessage, isError: testIsError, duration: 0.05) // Duração bem curta

        // Then
        XCTAssertEqual(sut.message, testMessage, "Message should be set")
        XCTAssertTrue(sut.isVisible, "isVisible should be true immediately")
        XCTAssertEqual(sut.isError, testIsError, "isError should be set correctly")
    }

    func testShowShouldHideMessageAfterDuration() {
        // Given
        let expectation = XCTestExpectation(description: "Feedback hides after duration")
        let duration: TimeInterval = 0.1

        // When
        sut.show(message: "Temporary", duration: duration)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.01) { [weak self] in
            guard let self = self else {
                XCTFail("Self (XCTestCase) was deallocated before expectation could be fulfilled.")
                return
            }

            // Then
            XCTAssertFalse(self.sut.isVisible, "isVisible should be false after duration")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: duration + 0.05)
    }
}
