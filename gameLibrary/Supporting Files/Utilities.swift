//
//  Utilies.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 07/03/2023.
//

import UIKit

extension String {
    func htmlToString() -> String {
        return  try! NSAttributedString(data: self.data(using: .utf8)!,
                                        options: [.documentType: NSAttributedString.DocumentType.html],
                                        documentAttributes: nil).string
    }
    func stringToGenres()-> [Genres]{
        let genreString = self.replacingOccurrences(of: C.oneSpace, with: C.noSpace)
        let genreNames = genreString.components(separatedBy: C.comma)
        var genres = [Genres]()
        for i in 0...genreNames.count - 1{
            let newGenre = Genres(name: genreNames[i])
            genres.append(newGenre)
        }
        return genres
    }
}


extension UIImageView{
    func getGradient(){
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
          UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.4, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer0.bounds = self.frame.insetBy(dx: -0.5 * self.frame.width, dy: -0.5 * self.frame.height)
        layer0.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.layer.addSublayer(layer0)
    }
}
