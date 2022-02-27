//
//  networkService.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import Foundation


class InvalidLoginCredentialsError: LocalizedError {
    var errorDescription: String? {
        return "Either username or password is not valid! Response does not contain sessionId"
    }
}

class NetworkService {
    
    private class func postRequest<Request: Codable, Response: Codable>(url: URL, request: Request ,responseType: Response.Type, completion: @escaping (Response?, Error?) -> Void) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {
            data, urlResponse, error  in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(Response.self, from: newData)

                completion(responseObject, nil)
            } catch {
                completion(nil, InvalidLoginCredentialsError())
            }
            
        }
        
        dataTask.resume()
        
    }
    
    private class func getRequest<Response: Decodable>(url: URL, responseType: Response.Type, completion: @escaping (Response?, Error?) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: url) {
            data, urlResponse, error  in
            guard let data = data else {
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }

                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(Response.self, from: newData)

                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }

            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        dataTask.resume()
        
    }
    
    class func login(userName:String, password:String, completion: @escaping (Bool, String?) -> Void) {
        
        let udacity = Udacity(username: userName, password: password)
        let loginRequest = LoginRequest(udacity: udacity)
        
        self.postRequest(url: Endpoints.authenticate.url, request: loginRequest,responseType: LoginResponse.self) {
            (loginResponse, error) in
            guard let loginResponse = loginResponse else {
                var message: String? = nil
                if let error = error {
                    message = error.localizedDescription
                }
                DispatchQueue.main.async {
                    completion(false, message)
                }

                return
            }
            
            if(!loginResponse.session.id.isEmpty) {
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }else{
                DispatchQueue.main.async {
                    completion(false, "Login Failed! No SessionId was returned.")
                }
            }
        }
    }
}
