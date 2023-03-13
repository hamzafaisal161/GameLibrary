

import UIKit

protocol GameDelegate{
    func setData()
}

class ListManager{
    
    var gameDelegate: GameDelegate?
    
    var games = [Game]()
    //API for loading details of all games
    func fetchCell(pageNo : Int){ //creates a URL for API and calls method for performing request
        let URL = C.listURL + String(pageNo)
        performRequest(with: URL)
    }
    
    private  func performRequest(with urlString: String){ //creates a URL session for network request
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
    
    private  func parseJSON(_ CellData: Data){ //parses the JSON format data into a Game type object
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
