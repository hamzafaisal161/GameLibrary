

import UIKit

class GameManager{
    
    var gameDelegate: GameDelegate?
    var gameIndex: GameDetail? = nil
    func fetchCell(id: Int){
        let URL = "\(C.gameURL)\(id)\(C.keyParam)\(C.apiKey)"
        performRequest(with: URL)
    }
    
    private  func performRequest(with urlString: String){
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
    
    private  func parseJSON(_ gameData: Data){
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
