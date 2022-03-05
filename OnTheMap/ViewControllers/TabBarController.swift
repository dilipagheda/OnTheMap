//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBAction func onLogoutTap(_ sender: Any) {
        
        NetworkService.logout() {
            (isSuccessful, errorMessage) in
            if(!isSuccessful) {
                guard let errorMessage = errorMessage else {
                    Alerts.setParentView(parentView: self)
                        .showError(errorMessage: "Sorry! Something went wrong!")
                    return
                }

                Alerts.setParentView(parentView: self)
                    .showError(errorMessage: errorMessage)
            }

            self.navigationController?.popToRootViewController(animated: true)

        }
    }
    
    @IBAction func onRefreshTap(_ sender: Any) {
        
        func invokeRefreshOnMapViewController() {
            let mapViewController = self.viewControllers![0] as! MapViewController
            mapViewController.refresh()
        }
        
        func invokeRefreshOnListViewController() {
            let listViewController = self.viewControllers![1] as! ListViewController
            listViewController.refresh()
        }
        
        let invocationMap: [Int: ()->Void] = [0: invokeRefreshOnMapViewController, 1: invokeRefreshOnListViewController]
        
        
        invocationMap[self.selectedIndex]!()
        
    }
    
}
