//
//  gameCell.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 24/02/2023.
//

import UIKit
import SwipeCellKit
import RealmSwift
import SnapKit

class GameCell: SwipeTableViewCell { //model for creating cell
    
    let gameImage = UIImageView()
    let genreView = UILabel()
    let scoreView = UILabel()
    let metaView = UILabel()
    let titleView = UILabel()
    let resultText = UILabel()
    var dbHandler =  RealmDBHandler()
    
    
    func setCell(game: FavoriteDetail){ //setting up a cell when its being added on Favorite screen
        self.scoreView.text = String(game.score)
        self.titleView.text = game.name
        let url = URL(string: game.imageURL)
        self.gameImage.sd_setImage(with: url, placeholderImage: UIImage(named: C.loaderImg))
        if game.genres.count > 0 {
            self.genreView.text = game.genres[0].name
            var i = 1
            while i < game.genres.count{
                self.genreView.text = self.genreView.text! + ", \(game.genres[i].name)"
                i += 1
            }
        }
    }
    
    
    func setCell(game: Game){ //setting up a cell when its being added on Game List screen
        
        self.prepareCell()
        if let score = game.metacritic {
            self.scoreView.text = String(score)
        }
        self.titleView.text = game.name
        let url = URL(string:game.background_image ?? "")
        self.gameImage.sd_setImage(with: url, placeholderImage: UIImage(named: C.loaderImg))
        if game.genres.count > 1{
           self.genreView.text = game.genres[0].name
        }
        var i = 1
        while i < game.genres.count{
            self.genreView.text?.append(", \(game.genres[i].name)")
            i += 1
        }
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0 )
        if dbHandler.isVisited(id: game.id){
            self.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1.0 )
        }
    }
    
    func prepareCell(){ //adding constraints to a cell
        self.addSubview(gameImage)
        self.addSubview(genreView)
        self.addSubview(scoreView)
        self.addSubview(metaView)
        self.addSubview(titleView)
        self.addSubview(resultText)
        gameImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(16)
            make.leading.equalTo(self).offset(16)
            make.size.equalTo(CGSize(width: 120, height: 124))

        }
        
        titleView.font = titleView.font.withSize(24)
        titleView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(16)
            make.left.equalTo(gameImage.snp.rightMargin).offset(24)
            make.right.equalTo(contentView).offset(16)
        }
        
        genreView.font = genreView.font.withSize(15)
        genreView.textColor = UIColor(red: 138/256, green: 138/256, blue: 143/256, alpha: 1.0)
        genreView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(gameImage.snp_bottomMargin).offset(6)
            make.left.equalTo(gameImage.snp.rightMargin).offset(24)
            make.right.equalTo(contentView).offset(16)
        }
        
        metaView.text = "metacritic: "
        metaView.font = metaView.font.withSize(16)
        metaView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleView.snp.topMargin).offset(60)
            make.left.equalTo(gameImage.snp.rightMargin).offset(24)
        }
        scoreView.font = scoreView.font.withSize(20)
        scoreView.textColor = UIColor(red: 216/256, green: 0/256, blue: 0/256, alpha: 1.0)
        scoreView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleView.snp.topMargin).offset(58)
            make.left.equalTo(metaView.snp.rightMargin).offset(6)
            make.right.equalTo(contentView).offset(16)
        }
        
    }
}


