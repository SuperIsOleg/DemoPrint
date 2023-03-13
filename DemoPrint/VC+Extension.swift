//
//  VC+Extension.swift
//  DemoPrint
//
//  Created by Oleg Kalistratov on 2.03.23.
//

import UIKit

extension UIViewController {
     func showAlert(text: String) {
         let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
        
    }
    
}
