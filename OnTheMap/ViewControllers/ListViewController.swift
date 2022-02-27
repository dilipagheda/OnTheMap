//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "onTheMapTableCell", for: indexPath)
            
        //let meme = memes[indexPath.row]
        
        //cell.memeImageView.image = meme.memedImage
        //cell.memeLabel.text = "\(meme.topText)...\(meme.bottomText)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

