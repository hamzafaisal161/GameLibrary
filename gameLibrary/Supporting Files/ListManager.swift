

import UIKit

protocol GameDelegate{
    func setData()
}

class ListManager{
    
    var gameDelegate: GameDelegate?
    
    var games = [Game]()
    
    func fetchCell(pageNo : Int){
        let URL = "https://api.rawg.io/api/games?page_size=10&key=3897ec2348af4eadb5048bcd1c109fce&page=" + String(pageNo)
        performRequest(with: URL)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data, response,error) in
                if error != nil{
                    print(error!)
                }
                if let safeData = data {
                    self.parseJSON(safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ CellData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ListData.self, from: CellData)
            for i in 0...decodedData.results.count - 1{
                games.append(decodedData.results[i])
            }
            gameDelegate?.setData()
        }catch{
            print(error)
        }
    }
}
