//
//  FoodModel.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import Foundation
import FirebaseFirestore

struct Food: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let name: String
    let restaurant: String
    let subtitle: String
    let price: Double
    let imagePath: String
    let description: String
}
