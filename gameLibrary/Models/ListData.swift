//
//  cellData.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 27/02/2023.
//

import UIKit

struct ListData: Decodable{
    let results: [Game]
}

struct Game: Decodable{
    let name: String
    let background_image: String?
    let metacritic: Int?
    let genres: [Genres]
    let id: Int
}

struct Genres: Decodable{
    let name: String
}
