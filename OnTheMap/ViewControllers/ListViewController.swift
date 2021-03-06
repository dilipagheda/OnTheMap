//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.refresh()
    }
    
    public func refresh() {
        
        ViewModel.results = []
        self.tableView.reloadData()
        
        NetworkService.getStudentLocations(){
            (results, error) in
            guard let results = results else {
                ViewModel.results = []
                Alerts.setParentView(parentView: self)
                    .showError(errorMessage: "Error while fetching student locations!")
                return
            }
            
            ViewModel.results = results
            self.tableView.reloadData()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ViewModel.results.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "onTheMapTableCell", for: indexPath)
            
        let result = ViewModel.results[indexPath.row]
        
        cell.textLabel!.text = "\(result.firstName) \(result.lastName)"
        cell.detailTextLabel!.text = result.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let result = ViewModel.results[indexPath.row]
        
        let url = URL(string: result.mediaURL)
        
        if let url = url {
            let app = UIApplication.shared
            app.open(url) {
                (isSuccessful) in
                if(!isSuccessful) {
                    Alerts.setParentView(parentView: self)
                          .showError(errorMessage: "Invalid URL")
                }
            }
        }
    }
    
}

