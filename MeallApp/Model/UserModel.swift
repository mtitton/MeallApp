//
//  Users.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import Foundation

struct UserModel: Codable {
    let uid: String
    let email: String
    let fullName: String
    
    var initials: String {
        let words = fullName
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        
        let initials = words.prefix(2).compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
}
