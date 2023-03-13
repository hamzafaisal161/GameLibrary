//
//  Alert.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 28/02/2023.
//

import UIKit

class Alert{
    
    func createAlert() -> UIAlertController{ //function for creating alert
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 20, y: 5, width: 50, height: 50))
        let alert = UIAlertController(title: nil, message: C.loaderMsg, preferredStyle: .alert)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        return alert
    }
}
