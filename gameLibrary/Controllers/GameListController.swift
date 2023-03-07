import UIKit
import SDWebImage
import RealmSwift


//MARK: Controller Methods


class GameListController: UIViewController, GameDelegate, SearchDelegate{
    
    var isDataLoading: Bool = false
    var pageNo: Int = 1
    var didEndReached: Bool = false
    var listManager = ListManager()
    var alertManager = Alert()
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var games = [Game]()
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    var searchManager = SearchManager()
    var dbHandler: DBHandler = RealmDBHandler()
    func setData() {
        DispatchQueue.main.async {
            self.games = self.listManager.games
            self.label.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            self.tableView.tableFooterView?.isHidden = true
            self.isDataLoading = false
        }
    }
    
    func setList(){
        DispatchQueue.main.async {
            self.games = self.searchManager.games
            self.label.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
            self.tableView.tableFooterView?.isHidden = true
            self.isDataLoading = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        searchManager.searchDelegate = self
        listManager.gameDelegate = self
        listManager.fetchCell(pageNo: pageNo)
        games = listManager.games
        let alert = alertManager.createAlert()
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Games"
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! GameViewController
                controller.id = games[indexPath.row].id
            }
        }
    }
    
}


//MARK: TableView Methods

extension GameListController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCell
        cell.setCell(game: games[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dbHandler.setVisited(id: games[indexPath.row].id)
        self.performSegue(withIdentifier: "goToGame", sender: self)
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading{
                let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
                
                isDataLoading = true
                self.pageNo = self.pageNo+1
                if searchBar.text != ""{
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        pageNo = 1
        games = []
        if searchBar.text == ""{
            games = listManager.games
        } else{
            searchManager.fetchCell(search: searchBar.text!,pageNo: pageNo)
            let alert = alertManager.createAlert()
            present(alert, animated: true, completion: nil)
        }
        if games.count == 0{
            tableView.isHidden = true
            label.isHidden = false
            label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 285)
            label.textAlignment = .center
            label.text = "No game has been found."
            label.font = UIFont.systemFont(ofSize: 20.0)
            self.view.addSubview(label)
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            pageNo = 1
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        setData()
    }
}
