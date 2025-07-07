//
//  CartItemModel.swift
//  MeallApp
//
//  Created by Marcus Titton on 04/07/25.
//

import Foundation

struct CartItemModel: Identifiable, Hashable {
    let id = UUID()
    let food: Food
    var quantity: Int
}
