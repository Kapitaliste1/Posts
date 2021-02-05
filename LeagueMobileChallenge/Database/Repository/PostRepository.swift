//
//  PostRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import Foundation
import ObjectMapper

class PostRepository {
    
    static let shared = PostRepository()
    
    func retrievePosts(successHandler : @escaping ([Post]) -> Void, failureHandler : @escaping (Error) -> Void){
        var posts : [Post] = [Post]()
        if let url : URL = URL(string: APIController.shared.postsAPI), APIController.shared.checkInternetAvalability(){
            APIController.shared.request(url: url) { (data, error) in
                
                guard error == nil else {
                    if let foundError = error as? RequestError, foundError == RequestError.userTokenIsNill{
                        APIController.shared.fetchUserToken(userName: "", password: "") { (erroUserToken) in
                            guard erroUserToken == nil else {
                                return
                            }
                            failureHandler(RequestError.userTokenIsNill)
                        }
                    }
                    return
                }                
                do {
                    if let jsonRawData = data as? Data{
                        let jsonParsed = try JSONSerialization.jsonObject(with: jsonRawData, options: .allowFragments) as! [[String : AnyObject]]
                        posts = Mapper<Post>().mapArray(JSONArray:jsonParsed)
                        successHandler(posts)
                    }
                } catch let parseError {
                    failureHandler(parseError)
                }
            }
        }else{
            failureHandler(RequestError.noInternetConntion)
        }
    }
}
