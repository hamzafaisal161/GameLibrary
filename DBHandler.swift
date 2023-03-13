//
//  DBHandler.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 06/03/2023.
//

import Foundation

protocol DBHandler { //protocol for DB setup
    func setVisited(id: Int)
    func isVisited(id: Int)-> Bool
    func addFavorite(game: GameDetail)
    func loadFavorites()-> [FavoriteDetail]
    func removeFavorite(id: Int)
    func isFavorite(id: Int)-> Bool
}
