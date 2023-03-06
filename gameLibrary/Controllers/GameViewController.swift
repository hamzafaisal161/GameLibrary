//
//  GameViewController.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 28/02/2023.
//

import UIKit
import RealmSwift
import SDWebImage
import ReadMoreTextView

class GameViewController: UIViewController, GameDelegate{
    
    var alertManager = Alert()
    var game: GameDetail?
    var id: Int?
    let realm = try! Realm()
    var games: Results<GameModel>?
    var gameManager = GameManager()
    var favorite = false
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager.gameDelegate = self
        DispatchQueue.main.async {
            self.gameManager.fetchCell(id: self.id!)
        }
        let alert = alertManager.createAlert()
        present(alert, animated: true, completion: nil)
    }
    
    func setData() {
        DispatchQueue.main.async {
            self.game = self.gameManager.gameIndex
            let url = URL(string:self.game?.background_image ?? "")
            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "activity.png"))
            var description  = self.game?.description.replacingOccurrences(of: "<p>", with: "", options: .literal, range: nil)
            description = description!.replacingOccurrences(of: "</p>", with: "", options: .literal, range: nil)
            description = description!.replacingOccurrences(of: "<br />", with: "", options: .literal, range: nil)
            self.descriptionLabel.text = description
            self.gameTitle.text = self.game?.name ?? "N/A"
            self.loadGames()
            var i = 0
            while i < self.games!.count{
                if self.games![i].id == self.game?.id {
                    self.favoriteButton.setTitle("Favorited", for: .normal)
                }
                i += 1
            }
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        if favoriteButton.titleLabel?.text == "Favorite"{
            do{
                try self.realm.write{
                    let newGame = GameModel()
                    newGame.id = self.game?.id ?? 0
                    newGame.name = self.game?.name ?? ""
                    newGame.genres = (self.game?.genres[0].name)!
                    for genre in 1...(self.game?.genres.count)! - 1{
                        newGame.genres = newGame.genres + ", \(self.game!.genres[genre].name)"
                    }
                    newGame.score = self.game!.metacritic
                    newGame.imageURL = self.game!.background_image
                    realm.add(newGame)
                    favoriteButton.setTitle("Favorited", for: .normal)
                }
            }catch{
                print("Error saving new item, \(error)")
            }
        }else{
            do{
                var i = 0
                while i < games!.count{
                    if games![i].id == game?.id{
                        try realm.write {
                            realm.delete(games![i])
                            favoriteButton.setTitle("Favorite", for: .normal)
                        }
                    }
                    i += 1
                }
            }catch{
                print("Error deleting item row, \(error)")
            }
        }
    }
    
    @IBAction func redditButton(_ sender: UIButton) {
        if let url = URL(string: game!.website) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func websiteButton(_ sender: Any) {
        if let url = URL(string: game!.reddit_url) {
            UIApplication.shared.open(url)
        }
    }
    
    func loadGames(){
        games = realm.objects(GameModel.self)
    }
    
}
