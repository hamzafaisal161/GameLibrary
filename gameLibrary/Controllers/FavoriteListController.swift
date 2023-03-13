//
//  FavoriteListController.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 28/02/2023.
//

import RealmSwift
import UIKit
import SwipeCellKit


//MARK: Controller Methods

class FavoriteListController: UIViewController{
    
    
    private var alertManager = Alert()
    var tableView = UITableView()
    var listView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    private var games = [FavoriteDetail]()
    private let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    private var dbHandler: DBHandler = RealmDBHandler()
    override func viewDidLoad() {
        self.prepareView()
        self.setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.setLabel()
        
    }
    
    func loadGames(){ //loading all the favorites
        games = dbHandler.loadFavorites()
        if games.count > 0{
            self.tabBarController?.title = "\(C.favourites) (\(games.count))"
        }
        tableView.reloadData()
        dismiss(animated: false, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //passing the id of the game to the GameViewController
        if segue.identifier == C.segueName {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! GameViewController
                controller.id = games[indexPath.row].id
            }
        }
        self.tabBarController?.title = C.favourites
    }
    
    private func setLabel(){ //displaying no favorites if there are no faovrites
        self.tabBarController?.title = C.favourites
        loadGames()
        if games.count == 0{
            tableView.isHidden = true
            label.isHidden = false
            label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 285)
            label.textAlignment = .center
            label.text = C.noFavourites
            label.font = UIFont.systemFont(ofSize: 20.0)
            self.view.addSubview(label)
        }else{
            tableView.isHidden = false
            label.isHidden = true
        }
    }
    
    private func setTableView(){ //setting up the tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameCell.classForCoder(), forCellReuseIdentifier: C.cellIdentifier)
        tableView.rowHeight = 156
        let alert = alertManager.createAlert()
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

//MARK: TableView Methods

extension FavoriteListController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController = GameViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
        newViewController.id = games[indexPath.row].id
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //populating the tableView with cells
        let cell = self.tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier) as! GameCell
        cell.delegate = self
        cell.prepareCell()
        cell.setCell(game: games[indexPath.row])
        return cell
    }
    
}


//MARK: SwipeCell Methods

extension FavoriteListController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil } //adding a swipe to open up a delete button action

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.dbHandler.removeFavorite(id: self.games[indexPath.row].id)
                self.setLabel()
            }
            deleteAction.image = UIImage(named: "delete")
            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions() //adding a swipe to delete option
        options.expansionStyle = .destructive(automaticallyDelete: false)
        options.transitionStyle = .border
        return options
    }
}
