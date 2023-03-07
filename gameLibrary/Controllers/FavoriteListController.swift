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
    
    var alertManager = Alert()
    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var games: Results<GameModel>?
    var visitedList: Results<VisitedList>?
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        let alert = alertManager.createAlert()
        present(alert, animated: true, completion: nil)
        tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Favourites"
        loadGames()
        if games?.count == 0{
            tableView.isHidden = true
            label.isHidden = false
            label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 285)
            label.textAlignment = .center
            label.text = "There is no favorite added."
            label.font = UIFont.systemFont(ofSize: 20.0)
            self.view.addSubview(label)
        }else{
            tableView.isHidden = false
            label.isHidden = true
        }
    }
    
    func loadGames(){
        games = realm.objects(GameModel.self)
        if games!.count > 0{
            self.tabBarController?.title = "Favourites (\(games!.count))"
        }
        tableView.reloadData()
        dismiss(animated: false, completion: nil)
    }
    
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! GameViewController
                controller.id = games![indexPath.row].id
            }
        }
        self.tabBarController?.title = "Favourites"
    }
    
    func loadVisited(){
        visitedList = realm.objects(VisitedList.self)
    }
    
    func updateModel(at indexPath: IndexPath){
        do{
            try realm.write {
                realm.delete(games![indexPath.row])
                if games!.count > 0{
                    self.tabBarController?.title = "Favourites (\(games!.count))"
                }else{
                    self.tabBarController?.title = "Favourites"
                }            }
        }
        catch{
            print("Error deleting item row, \(error)")
        }
    }
    
}
 
 //MARK: TableView Methods

extension FavoriteListController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToGame", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCell
        cell.delegate = self
        cell.scoreView.text = String(games![indexPath.row].score)
        cell.titleView.text = games![indexPath.row].name
        let url = URL(string:games![indexPath.row].imageURL)
        cell.gameImage.sd_setImage(with: url, placeholderImage: UIImage(named: "activity.png"))
        cell.genreView.text = games![indexPath.row].genres
        return cell
    }
    
}


//MARK: SwipeCell Methods

extension FavoriteListController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
