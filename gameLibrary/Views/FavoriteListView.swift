//
//  FavoriteListView.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 13/03/2023.
//

import UIKit

extension FavoriteListController{
    func prepareView(){
        self.view.addSubview(listView)
        listView.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1.0)
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(listView.snp.top).offset(150)
            make.leading.equalTo(listView.snp.leading)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            make.bottom.equalTo(listView.snp.bottom)
        }
    }
}
