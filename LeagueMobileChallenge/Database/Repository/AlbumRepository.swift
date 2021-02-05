//
//  AlbumRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

class AlbumRepository {
    
    static let shared = AlbumRepository()
    
    func retrieveAlbums(successHandler : @escaping ([Album]) -> Void, failureHandler : @escaping (Error) -> Void){
        var albums : [Album] = [Album]()
        if let url : URL = URL(string: APIController.shared.albumsAPI), APIController.shared.checkInternetAvalability(){
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
                        albums = Mapper<Album>().mapArray(JSONArray:jsonParsed)
                        successHandler(albums)
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
