//
//  APIController.swift
//  LeagueMobileChallenge
//
//  Created by Kelvin Lau on 2019-01-14.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire

public enum RequestError : Error {
    case userTokenIsNill
    case requestFailed
    case noInternetConntion
    case emailAccountUnavailable
    case wrongPhoneNumberFormat
}

class APIController {
    static let user = "user"
    static let password = "password"
    
    static let domain = "https://engineering.league.dev/challenge/api/"
    let loginAPI = domain + "login"
    let usersAPI = domain + "users"
    let postsAPI = domain + "posts"
    let albumsAPI = domain + "albums"
    let photosAPI = domain + "photos"
    
    static let shared = APIController()
    
    fileprivate var userToken: String?
    
    func fetchUserToken(userName: String, password: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: loginAPI) else {
            return
        }
        let headers: HTTPHeaders = [
            .authorization(username: userName, password: password),
            .accept("application/json")
        ]
        
        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                if let content = value as? [AnyHashable : Any] {
                    self.userToken = content["api_key"] as? String
                }
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }
    
    func request(url: URL, completion: @escaping (Any?, Error?) -> Void) {
        guard let userToken = userToken else {
            NSLog("No user token set")
            completion(nil, RequestError.userTokenIsNill)
            return
        }
        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
        
        AF.request(url, method: .get
                   , parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
                    completion(response.data, response.error)
                   }
    }
    
    func checkInternetAvalability() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}
