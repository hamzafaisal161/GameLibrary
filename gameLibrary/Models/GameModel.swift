//
//  GameModel.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 27/02/2023.
//

import Foundation
import RealmSwift

class GameModel: Object{ // model for Realm DB to store favorite game detail
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var score: Int = 0
    @objc dynamic var genres: String = ""
    @objc dynamic var id: Int = 0
}

