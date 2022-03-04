//
//  Alerts.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 2/3/22.
//

import Foundation
import UIKit

class Alerts
{
    private static var parentView: UIViewController? = nil
    
    class func setParentView(parentView view: UIViewController) -> Alerts.Type
    {
        self.parentView = view
        
        return self
    }
    
    class func showError(errorMessage message: String)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
        alert.addAction(alertAction)
        
        guard let parentView = parentView else {
            return
        }
        
        parentView.present(alert, animated: true, completion: nil)
    }
}
