//
//  RestaurantModel.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import Foundation
import FirebaseFirestore

struct Restaurant: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var restaurant: String
    var imagePath: String
}
