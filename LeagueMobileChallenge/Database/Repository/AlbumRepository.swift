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
    
    func downloadAlbums(successHandler : @escaping ([Album]) -> Void, failureHandler : @escaping (Error) -> Void){
        var albums : [Album] = [Album]()
        if let url : URL = URL(string: APIController.shared.albumsAPI), APIController.shared.checkInternetAvalability(){
            APIController.shared.request(url: url) { (data) in
                do {
                    if let jsonRawData = data as? Data{
                        let jsonParsed = try JSONSerialization.jsonObject(with: jsonRawData, options: .allowFragments) as! [[String : AnyObject]]
                        albums = Mapper<Album>().mapArray(JSONArray:jsonParsed)
                        APIController.shared.saveBatchInLocalStorage(albums) { (savedData) in
                            successHandler(albums)
                        } failureHandler: { (error) in
                            failureHandler(error)
                        }
                        
                    }
                } catch let parseError {
                    failureHandler(parseError)
                }
            } failureHandler: { (error) in
                failureHandler(error)
            }
            
        }else{
            failureHandler(RequestError.noInternetConntion)
        }
    }
    
    func selectAll(successHandler : @escaping ([Album]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(Album.fetchRequest()) as? [Album]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
}
