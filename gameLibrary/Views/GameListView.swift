//
//  GameListView.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 13/03/2023.
//

import UIKit


extension GameListController{
    func prepareView(){
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(GameCell.classForCoder(), forCellReuseIdentifier: C.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        searchManager.searchDelegate = self
        listManager.gameDelegate = self
        listManager.fetchCell(pageNo: pageNo)
        games = listManager.games
    }
    
    
    func prepareScreen(){
        self.view.addSubview(listView)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        searchBar.placeholder = "Search for the games"
        searchBar.delegate = self
        searchBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(listView).offset(150)
            make.size.equalTo(CGSize(width: listView.frame.width, height: 50))
            make.leading.equalTo(listView.snp.leading)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(searchBar.snp.bottom).offset(0)
            make.leading.equalTo(listView.snp.leading)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            make.bottom.equalTo(listView.snp.bottom).inset(20)
        }
    }
}
