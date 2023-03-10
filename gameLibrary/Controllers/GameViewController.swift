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
    
    override func viewDidLoad() {
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
    
    func setData() {
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
    
    @objc func favoritePressed(sender: UIBarButtonItem) {
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
    
    
    func setupView(){
        self.view.addSubview(displayView)
        self.navigationItem.rightBarButtonItem = favoriteButton
        displayView.addSubview(descriptionLabel)
        displayView.addSubview(gameDescription)
        displayView.addSubview(firstSeperator)
        displayView.addSubview(imageView)
        displayView.addSubview(gameTitle)
        displayView.addSubview(redditButton)
        displayView.addSubview(secondSeperator)
        displayView.addSubview(websiteButton)
        displayView.backgroundColor = UIColor.white
        favoriteButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoritePressed))
        gameTitle.font = gameTitle.font.withSize(34)
        gameTitle.textColor = UIColor.white
        gameDescription.text = "Game Description"
        gameDescription.font = gameDescription.font.withSize(22)
        gameDescription.textColor = UIColor(red: 49/256, green: 49/256, blue: 49/256, alpha: 1)
        descriptionLabel.numberOfLines = 4
        descriptionLabel.font = descriptionLabel.font.withSize(13)
        redditButton.setTitle("Visit Reddit", for: .normal)
        redditButton.addTarget(self, action: #selector(self.redditClicked), for: .touchUpInside)
        firstSeperator.backgroundColor = UIColor.systemGray5
        redditButton.setTitleColor(.black, for: .normal)
        redditButton.contentHorizontalAlignment = .left
        redditButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        websiteButton.setTitleColor(.black, for: .normal)
        websiteButton.contentHorizontalAlignment = .left
        websiteButton.setTitle("Visit Website", for: .normal)
        websiteButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        secondSeperator.backgroundColor = UIColor.systemGray5
        setupConstraints()
    
    }
    
    func setupConstraints(){
        imageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(displayView.snp.topMargin).offset(0)
            make.leading.equalTo(displayView.snp.leading).offset(0)
            make.bottom.equalTo(displayView.snp.topMargin).offset(300)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 300))
        }
       
        
        gameTitle.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(imageView.snp.bottomMargin).inset(8)
            make.trailing.equalTo(displayView.snp.trailing).inset(16)
        }
        
        
        gameDescription.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageView.snp.bottomMargin).offset(19)
            make.leading.equalTo(displayView.snp.leading).offset(19)
            make.trailing.equalTo(displayView.snp.trailing).inset(19)
        }
       
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(gameDescription.snp.bottomMargin).offset(10)
            make.leading.equalTo(displayView.snp.leading).offset(19)
            make.trailing.equalTo(displayView.snp.trailing).inset(19)
        }
        
        firstSeperator.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottomMargin).offset(30)
            make.trailing.equalTo(displayView.snp.trailing).offset(0)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width * 0.95, height: 1))
        }
        
       
        redditButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(firstSeperator.snp.bottomMargin).offset(10)
            make.leading.equalTo(displayView.snp.leading).offset(19)
            make.trailing.equalTo(displayView.snp.trailing).inset(19)
        }
        
        secondSeperator.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(redditButton.snp.bottomMargin).offset(20)
            make.trailing.equalTo(displayView.snp.trailing).offset(0)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width * 0.95, height: 1))
        }
        
        
        websiteButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(secondSeperator.snp.bottomMargin).offset(10)
            make.leading.equalTo(displayView.snp.leading).offset(19)
            make.trailing.equalTo(displayView.snp.trailing).inset(19)
        }
    }
}
