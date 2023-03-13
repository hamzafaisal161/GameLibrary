//
//  FavoriteDetail.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 06/03/2023.
//

import Foundation

struct FavoriteDetail{ //model for loading data from Dealm for favorite game
    var name: String
    var imageURL: String
    var score: Int
    var genres: [Genres]
    var id: Int
}
