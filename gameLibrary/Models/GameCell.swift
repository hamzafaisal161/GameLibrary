//
//  gameCell.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 24/02/2023.
//

import UIKit
import SwipeCellKit
import RealmSwift

class GameCell: SwipeTableViewCell {
    
    @IBOutlet weak var genreView: UILabel!
    @IBOutlet weak var scoreView: UILabel!
    @IBOutlet weak var metaView: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var resultText: UILabel!
    var dbHandler =  RealmDBHandler()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(game: Game){
        if let score = game.metacritic {
            self.scoreView.text = String(score)
        }
        self.titleView.text = game.name
        let url = URL(string:game.background_image ?? "")
        self.gameImage.sd_setImage(with: url, placeholderImage: UIImage(named: "activity.png"))
        if game.genres.count > 1{
            self.genreView.text = game.genres[0].name
        }
        var i = 1
        while i < game.genres.count{
            self.genreView.text?.append(", \(game.genres[i].name)")
            i += 1
        }
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0 )
        if dbHandler.isVisited(id: game.id){
            self.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1.0 )
        }
    }
}


