//
//  Alert.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 28/02/2023.
//

import UIKit

class Alert{
    
    func createAlert() -> UIAlertController{
        var loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 20, y: 5, width: 50, height: 50))
        var alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        return alert
    }
}
