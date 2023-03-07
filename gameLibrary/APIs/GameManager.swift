

import UIKit

class GameManager{
    
    var gameDelegate: GameDelegate?
    var gameIndex: GameDetail? = nil
    func fetchCell(id: Int){
        let URL = "https://api.rawg.io/api/games/\(id)?key=3897ec2348af4eadb5048bcd1c109fce"
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
    
    func parseJSON(_ gameData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GameDetail.self, from: gameData)
            gameIndex = decodedData
            gameDelegate?.setData()
        }catch{
            print(error)
        }
    }
    
    func getGame()-> GameDetail{
        return gameIndex!
    }
}
