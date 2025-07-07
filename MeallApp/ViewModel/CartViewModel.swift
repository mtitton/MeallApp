//
//  CartViewModel.swift
//  MeallApp
//
//  Created by Marcus Titton on 04/07/25.
//

import Foundation

class CartViewModel: ObservableObject {
    @Published var items: [CartItemModel] = []

    func addToCart(_ food: Food, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.food.id == food.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItemModel(food: food, quantity: quantity))
        }
    }

    func removeFromCart(_ item: CartItemModel) {
        items.removeAll { $0.id == item.id }
    }

    func clearCart() {
        items.removeAll()
    }

    var total: Double {
        items.reduce(0) { $0 + ($1.food.price * Double($1.quantity)) }
    }
    
    func decreaseQuantity(for food: Food) {
        if let index = items.firstIndex(where: { $0.food.id == food.id }) {
            items[index].quantity -= 1
            if items[index].quantity <= 0 {
                items.remove(at: index)
            }
        }
    }
}
