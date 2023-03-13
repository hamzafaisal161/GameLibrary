import UIKit
import SDWebImage
import RealmSwift
import SnapKit

//MARK: Controller Methods

class GameListController: UIViewController{
    
    private var isDataLoading: Bool = false
    var pageNo: Int = 1
    private var didEndReached: Bool = false
    var listManager = ListManager()
    var alertManager = Alert()
    var tableView = UITableView()
    var games = [Game]()
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    var searchManager = SearchManager()
    var dbHandler: DBHandler = RealmDBHandler()
    var searchBar = UISearchBar()
    var listView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    override func viewDidLoad() {
        self.prepareScreen()
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) { //setting up the tableview and title
        self.tabBarController?.title = C.games
        tableView.rowHeight = 156
        tableView.reloadData()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        if games.count == 0{
            let alert = alertManager.createAlert()
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {  //passing the id of the game to the GameViewController
        if segue.identifier == C.segueName{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! GameViewController
                controller.id = games[indexPath.row].id
            }
        }
    }
    
}


//MARK: TableView Methods
extension GameListController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //creating a cekk for the tableView
        let cell = self.tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier) as! GameCell
        cell.setCell(game: games[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //setting a game as visited when it is clicked
        dbHandler.setVisited(id: games[indexPath.row].id)
        let newViewController = GameViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
        newViewController.id = games[indexPath.row].id
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
}


//MARK: ScrollBar Methods
extension GameListController: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { //if the next page is loaded then fetch next page of games
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading{
                let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)  //create a loader
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                if searchBar.text != C.noSpace {
                    searchManager.fetchCell(search: searchBar.text!,pageNo: pageNo)
                }else{
                    listManager.fetchCell(pageNo: pageNo)
                }
            }
        }
    }
}


//MARK: SearchBar Methods
extension GameListController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { //if a game was searched
        pageNo = 1
        games = []
        if searchBar.text == C.noSpace {
            games = listManager.games
        } else{
            searchManager.fetchCell(search: searchBar.text!,pageNo: pageNo) // if a game was returned
            let alert = alertManager.createAlert()
            present(alert, animated: true, completion: nil)
        }
        if games.count == 0{ // if no result was returned then display label
            tableView.isHidden = true
            label.isHidden = false
            label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 285)
            label.textAlignment = .center
            label.text = C.emptySearch
            label.font = UIFont.systemFont(ofSize: 20.0)
            self.view.addSubview(label)
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //display all games if no search
        if searchBar.text?.count == 0 {
            pageNo = 1
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        setData()
    }
}

//MARK: GameDelegate Methods
extension GameListController: GameDelegate{
    func setData() { // load all the games
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.games = self.listManager.games
            self.label.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            self.tableView.tableFooterView?.isHidden = true
            self.isDataLoading = false
        }
    }
}


//MARK: SearchDelegate Methods
extension GameListController: SearchDelegate{
    func setList(){ // display the search result
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.games = self.searchManager.games
            self.label.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            self.tableView.tableFooterView?.isHidden = true
            self.isDataLoading = false
        }
    }
}
