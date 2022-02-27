//
//  Endpoints.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation


enum Endpoints {
    
    case authenticate
    case studentLocation
    
    var url: URL {
        
        switch(self) {
        case .authenticate:
            return URL(string: "https://onthemap-api.udacity.com/v1/session")!
        case .studentLocation:
            return URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!
        }
    }
}
