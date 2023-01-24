//
//  Follower.swift
//
//  Created by Rashad Surratt on 1/13/23.
//

import Foundation

struct Follower: Codable, Hashable, Identifiable {
    
    let id: Int
    var login:     String
    var avatarUrl: String
    
    static func ==(lhs: Follower, rhs: Follower) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
}
