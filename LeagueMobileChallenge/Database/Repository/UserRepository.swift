//
//  UserRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import Foundation
import ObjectMapper

class UserRepository {
    
    static let shared = UserRepository()
    
    func retrieveUser(completed : @escaping ([User]?) -> Void){
        var users : [User] = [User]()
        if let url : URL = URL(string: APIController.shared.usersAPI){
            APIController.shared.request(url: url) { (data, error) in
                guard error == nil else {
                    if let foundError = error as? RequestError, foundError == RequestError.userTokenIsNill{
                        APIController.shared.fetchUserToken(userName: "", password: "") { (erroUserToken) in
                            guard erroUserToken == nil else {
                                return
                            }
                            completed(nil)
                        }
                    }
                    return
                }
                do {
                    if let jsonRawData = data as? Data{
                        let jsonParsed = try JSONSerialization.jsonObject(with: jsonRawData, options: .allowFragments) as! [[String : AnyObject]]
                        users = Mapper<User>().mapArray(JSONArray:jsonParsed)
                        print("## \(users)")
                        completed(users)
                    }
                } catch let parseError {
                    print("JSON Error \(parseError.localizedDescription)")
                    completed(nil)
                }
            }
        }else{
            completed(nil)
        }
    }
}
