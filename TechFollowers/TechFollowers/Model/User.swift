//
//  User.swift
//
//  Created by Rashad Surratt on 1/13/23.
//

import Foundation

struct User: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
}
