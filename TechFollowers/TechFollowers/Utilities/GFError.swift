//
//  GFError.swift
//
//  Created by Rashad Surratt on 1/16/23.
//

import Foundation

enum GFError: String, Error {
    
    case invalidUserName    = "Username created is an invalid request, please try again."
    case unableToComplete   = "Unable to complete request, please check you connection"
    case invalidResponse    = "Response was invalid from the server, please try again."
    case invalidData        = "The data recieved from the server was invalid, please try again."
    case unableToFavorite   = "Issue while adding user to favoritesk please try again."
    case alreadyInFavorites = "User is already in your favorites."
}
