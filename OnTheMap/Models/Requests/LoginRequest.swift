//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation

struct Udacity: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: Udacity
}
