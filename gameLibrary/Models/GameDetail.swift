//
//  detailData.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 01/03/2023.
//

import Foundation

struct GameDetail: Decodable{ //model for loading game detail from Realm
    let name: String
    let id: Int
    let description: String
    let website: String
    let reddit_url: String
    let background_image: String
    let metacritic: Int?
    let genres: [Genres]
}
