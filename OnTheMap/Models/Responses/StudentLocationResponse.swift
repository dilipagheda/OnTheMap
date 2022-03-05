//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation

struct StudentInformation : Codable {
    
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}

struct StudentLocationResponse : Codable {
    
    let results: [StudentInformation]
}
