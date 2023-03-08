//
//  Constants.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 07/03/2023.
//

import Foundation


struct C{
    static let segueName: String = "goToGame"
    static let cellIdentifier: String = "GameCell"
    static let oneSpace: String = " "
    static let noSpace: String = ""
    static let comma: String = ","
    static let newError: String = "Error saving new item,"
    static let deleteError: String = "Error deleting item row,"
    static let realmError: String = "Error initialising new realm,"
    static let defaultConfig: String = "Default Configuration"
    static let loaderMsg: String = "Please wait..."
    static let moreMsg: String = "Read more..."
    static let lessMsg: String = "Read less..."
    static let games: String = "Games"
    static let emptySearch: String = "No game has been found."
    static let deleteAction: String = "Delete"
    static let deleteImg: String = "delete"
    static let loaderImg: String = "activity.png"
    static let notA: String = "N/A"
    static let favorited: String = "Favorited"
    static let favorite: String = "Favorite"
    static let favourites: String = "Favourites"
    static let noFavourites: String = "There is no favorite added."
    static let apiKey: String = "3897ec2348af4eadb5048bcd1c109fce"
    static let pageSize: String = "10"
    static let listURL: String = "https://api.rawg.io/api/games?page_size=\(C.pageSize)&key=\(C.apiKey)&page="
    static let gameURL: String = "https://api.rawg.io/api/games/"
    static let keyParam: String = "?key="
    static let searchURL: String = "https://api.rawg.io/api/games?page_size=10&key=3897ec2348af4eadb5048bcd1c109fce&search="
    static let pageParam: String = "&page="
}
