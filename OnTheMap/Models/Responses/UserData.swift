//
//  UserData.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 8/3/22.
//

import Foundation


struct UserDataResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
