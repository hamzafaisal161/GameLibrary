//
//  GameDetailView.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 13/03/2023.
//

import UIKit


extension GameViewController{
    func setupView(){
        favoriteButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoritePressed))
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
