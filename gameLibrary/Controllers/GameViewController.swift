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
    
    
    @IBOutlet weak var gradientView: UIView!
    private var alertManager = Alert()
    private var game: GameDetail?
    var id: Int?
    private var games =  [FavoriteDetail]()
    private var gameManager = GameManager()
    private var dbHandler: DBHandler = RealmDBHandler()
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager.gameDelegate = self
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.gameManager.fetchCell(id: self.id!)
        }
        let alert = alertManager.createAlert()
        present(alert, animated: true, completion: nil)
    }
    
    func setData() {
        DispatchQueue.main.async { [weak self] in
            guard let self  else { return }
            self.game = self.gameManager.gameIndex
            let url = URL(string:self.game?.background_image ?? C.noSpace)
            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: C.loaderImg))
            self.imageView.getGradient()
            self.descriptionLabel.text = self.game?.description.htmlToString()
            self.gameTitle.text = self.game?.name ?? C.notA
            self.loadGames()
            var i = 0
            while i < self.games.count{
                if self.games[i].id == self.game?.id {
                    self.favoriteButton.setTitle(C.favorited, for: .normal)
                }
                i += 1
            }
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        if favoriteButton.titleLabel?.text == C.favorite{
            favoriteButton.setTitle(C.favorited, for: .normal)
            dbHandler.addFavorite(game: game!)
            
        }else{
            favoriteButton.setTitle(C.favorite, for: .normal)
            dbHandler.removeFavorite(id: game!.id)
            
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
        games = dbHandler.loadFavorites()
    }
    
}
