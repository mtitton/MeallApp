//
//  FeedbackViewModel.swift
//  MeallApp
//
//  Created by Marcus Titton on 06/07/25.
//

import Foundation

class FeedbackViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var isVisible: Bool = false
    @Published var isError: Bool = false

    func show(message: String, isError: Bool = false, duration: TimeInterval = 2) {
        self.message = message
        self.isError = isError
        self.isVisible = true

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isVisible = false
        }
    }
}
