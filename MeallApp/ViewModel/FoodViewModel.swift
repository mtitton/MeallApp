//
//  FoodViewModel.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import Foundation

class FoodViewModel: ObservableObject {

    @Published var allFoods: [Food] = []  // guarda todas
    @Published var filteredFoods: [Food] = []  // exibe na tela

    private let foodService: FoodFetchingService

    init(foodService: FoodFetchingService = FirestoreFoodService()) {
        self.foodService = foodService
    }

    func fetchFoods(filteredBy name: String? = nil) {
        foodService.fetchFoods { [weak self] foods in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.allFoods = foods
                self.filterFoods(byRestaurantName: name)
            }
        }
    }

    func filterFoods(byRestaurantName name: String?) {
        guard let name = name else {
            filteredFoods = allFoods
            return
        }

        filteredFoods = allFoods.filter { $0.restaurant == name }
    }
}

