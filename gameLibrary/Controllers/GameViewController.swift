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
    
    
    private var alertManager = Alert()
    private var game: GameDetail?
    var id: Int?
    private var games =  [FavoriteDetail]()
    private var gameManager = GameManager()
    private var dbHandler: DBHandler = RealmDBHandler()
    var displayView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var imageView = UIImageView()
    var gameTitle = UILabel()
    var gameDescription = UILabel()
    var descriptionLabel = ExpandableLabel()
    var firstSeperator = UIView()
    var redditButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
    var secondSeperator = UIView()
    var favoriteButton =  UIBarButtonItem()
    var websiteButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
    
    override func viewDidLoad() { //fetch the details of the game
        super.viewDidLoad()
        self.setupView()
        gameManager.gameDelegate = self
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.gameManager.fetchCell(id: self.id!)
        }
        let alert = alertManager.createAlert()
        present(alert, animated: true, completion: nil)
    }
    
    func setData() { //display the game
        DispatchQueue.main.async { [weak self] in
            guard let self  else { return }
            self.game = self.gameManager.gameIndex
            let url = URL(string:self.game?.background_image ?? C.noSpace)
            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: C.loaderImg))
            self.imageView.getGradient()
            self.descriptionLabel.text = self.game?.description.htmlToString()
            self.descriptionLabel.addReadMoreButton()
            self.gameTitle.text = self.game?.name ?? C.notA
            self.loadGames()
            var i = 0
            while i < self.games.count{
                if self.games[i].id == self.game?.id {
                    self.favoriteButton.title = C.favorited
                }
                i += 1
            }
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @objc func favoritePressed(sender: UIBarButtonItem) { //when the favorite button is clicked
        if favoriteButton.title == C.favorite{
            favoriteButton.title = C.favorited
            dbHandler.addFavorite(game: game!)
            
        }else{
            favoriteButton.title = C.favorite
            dbHandler.removeFavorite(id: game!.id)
            
        }
    }
    
    @objc func redditClicked(_ sender: UIButton) { 
            if let url = URL(string: game!.reddit_url) {
                UIApplication.shared.open(url)
            }
        }
    
    @objc func websiteClicked(_ sender: UIButton) {
        if let url = URL(string: game!.website) {
                UIApplication.shared.open(url)
            }
        }
    
    func loadGames(){
        games = dbHandler.loadFavorites()
    }
        
}
