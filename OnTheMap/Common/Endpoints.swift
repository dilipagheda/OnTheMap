//
//  Endpoints.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation


enum Endpoints {
    
    case authenticate
    case delete
    case userdata
    case studentLocation(isGetRequest: Bool)
    
    var url: URL {
        
        switch(self) {
        case .authenticate:
            return URL(string: "https://onthemap-api.udacity.com/v1/session")!
        case .delete:
            return URL(string: "https://onthemap-api.udacity.com/v1/session")!
        case .userdata:
            return URL(string: "https://onthemap-api.udacity.com/v1/users/fakeUserId")!
        case let .studentLocation(isGetRequest):
            if(isGetRequest) {
                return URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!
            }
            return URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!
        }
    }
}
