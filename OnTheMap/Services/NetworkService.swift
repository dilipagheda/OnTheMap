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

class GenericError: LocalizedError {
    var errorDescription: String? {
        return "Sorry! Something went wrong!"
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
            let newData = url.absoluteString == Endpoints.authenticate.url.absoluteString ? data.subdata(in: range) : data
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(Response.self, from: newData)

                completion(responseObject, nil)
            } catch {
                let error: LocalizedError = url.absoluteString == Endpoints.authenticate.url.absoluteString ? InvalidLoginCredentialsError() : GenericError()
                
                completion(nil, error)
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
            let newData = url.absoluteString == Endpoints.userdata.url.absoluteString ? data.subdata(in: range) : data
           
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
    
    class func logout(completion: @escaping (Bool, String?) -> Void) {
        
        var request = URLRequest(url: Endpoints.delete.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, urlResponse, error  in
            guard let data = data else {
                guard let error = error else {
                    DispatchQueue.main.async {
                        completion(false, "Sorry! Something went wrong!")
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            
            do {
                let _ = try decoder.decode(LogoutResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(true, "Sorry! Something went wrong!")
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
    
    class func getStudentLocations(completion: @escaping ([StudentInformation]?, String?) -> Void) {
        
        self.getRequest(url: Endpoints.studentLocation(isGetRequest: true).url, responseType: StudentLocationResponse.self) {
            
            (studentLocationResponse, error) in
            guard let studentLocationResponse = studentLocationResponse else {
                
                DispatchQueue.main.async {
                    completion(nil, error?.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(studentLocationResponse.results, nil)
            }

        }
        
    }

    class func getUserData(completion: @escaping (Bool) -> Void) {
        
        self.getRequest(url: Endpoints.userdata.url, responseType: UserDataResponse.self) {
            
            (userDataResponse, error) in
            guard let userDataResponse = userDataResponse else {
                
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            DispatchQueue.main.async {
                ViewModel.firstName = userDataResponse.firstName
                ViewModel.lastName = userDataResponse.lastName
                completion(true)
            }

        }
        
    }

    
    class func postStudentLocation(studentLocationRequest: StudentLocationRequest, completion: @escaping (Bool, String?) -> Void) {
        
        self.postRequest(url: Endpoints.studentLocation(isGetRequest: false).url, request: studentLocationRequest, responseType: StudentLocationPostResponse.self) {
            (studentLocationPostResponse, error) in
            guard let studentLocationPostResponse = studentLocationPostResponse else {
                var message: String? = nil
                if let error = error {
                    message = error.localizedDescription
                }
                DispatchQueue.main.async {
                    completion(false, message)
                }

                return
            }
            
            if(!studentLocationPostResponse.objectId.isEmpty) {
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }else{
                DispatchQueue.main.async {
                    completion(false, "Can not add a location! No objectId was returned.")
                }
            }
        }
        
    }
}
