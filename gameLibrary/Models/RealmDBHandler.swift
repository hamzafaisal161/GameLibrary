//
//  RealmDBHandler.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 06/03/2023.
//

import Foundation
import RealmSwift

class RealmDBHandler : DBHandler{
    
    let realm = try! Realm()
    var visited: Results<VisitedList>?
    var favorites: Results<GameModel>?
    init(){
        visited = realm.objects(VisitedList.self)
    }
    
    func setVisited(id: Int) {
        if self.isVisited(id: id) == false{
            do{
                try self.realm.write{
                    let visitedGame = VisitedList()
                    visitedGame.id = id
                    realm.add(visitedGame)
                }
            }catch{
                print("\(C.newError) \(error)")
            }
        }
    }
    
    func isVisited(id: Int)-> Bool {
        var i = 0
        while i < visited!.count{
            if visited![i].id == id{
                return true
            }
            i += 1
        }
        return false
    }
    
    func addFavorite(game: GameDetail) {
        if isFavorite(id: game.id) == false{
            let favoriteGame = GameModel()
            favoriteGame.id = game.id
            if game.metacritic != nil{
                favoriteGame.score = game.metacritic!
            }
            favoriteGame.name = game.name
            favoriteGame.genres = game.genres[0].name
            for genre in 1...game.genres.count - 1
            {
                favoriteGame.genres = favoriteGame.genres + ", \(game.genres[genre].name)"
            }
            if game.background_image != C.noSpace{
                favoriteGame.imageURL = game.background_image
            }
            do{
                try self.realm.write{
                    realm.add(favoriteGame)
                }
            }catch{
                print("\(C.newError) \(error)")
            }
        }
    }
    
    func loadFavorites() -> [FavoriteDetail] {
        favorites = realm.objects(GameModel.self)
        var i = 0
        var games =  [FavoriteDetail]()
        while i < favorites!.count{
            let genres = favorites![i].genres.stringToGenres()
            let game = FavoriteDetail(name: favorites![i].name, imageURL: favorites![i].imageURL, score: favorites![i].score, genres: genres, id: favorites![i].id)
            i += 1
            games.append(game)
        }
        return games
    }
    
    func removeFavorite(id: Int) {
        if isFavorite(id: id){
            do{
                var i = 0
                while i < favorites!.count {
                    if id == favorites![i].id{
                        try realm.write {
                            realm.delete(favorites![i])
                        }
                    }
                    i += 1
                }
            }
            catch{
                print("\(C.deleteError) \(error)")
            }
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        var i = 0
        while i < favorites!.count{
            if id == favorites![i].id{
                return true
            }
            i += 1
        }
        return false
    }
    
}
