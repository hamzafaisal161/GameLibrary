

import UIKit

protocol SearchDelegate{
    func setList()
}
class SearchManager{
    
    var searchDelegate: SearchDelegate?
    var games = [Game]()
    
    func fetchCell(search : String, pageNo: Int){
        let URL = C.searchURL + search + "\(C.pageParam)\(pageNo)"
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
    
    private  func parseJSON(_ CellData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ListData.self, from: CellData)
            for i in 0...decodedData.results.count - 1{
                games.append(decodedData.results[i])
            }
            searchDelegate?.setList()
        }catch{
            print(error)
        }
    }
}
