//
//  UserRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import Foundation
 
class UserRepository {
    
    static let shared = UserRepository()
    
    func retrieveUser() -> [User]? {
        var toReturn : [User] = [User]()
        if let url : URL = URL(string: APIController.shared.usersAPI){
            APIController.shared.request(url: url) { (data, error) in
                guard error == nil else {
                    if let foundError = error as? RequestError, foundError == RequestError.userTokenIsNill{
                        print("### No token was found \(foundError)")
                        APIController.shared.fetchUserToken(userName: "", password: "") { (erroUserToken) in
                            guard erroUserToken == nil else {
                                print("### Could not fetch new token \(foundError)")
                                return
                            }
                        }
                    }
                    return
                }
                
                print("### data \(data)")

            }
        }
        return toReturn
    }
    
        
}
