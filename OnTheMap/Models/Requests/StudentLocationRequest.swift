//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation

struct StudentLocationRequest: Codable {
    var firstName: String
    var lastName: String
    var longitude: Double
    var latitude: Double
    var mapString: String
    var mediaURL: String
    var uniqueKey: String
}

