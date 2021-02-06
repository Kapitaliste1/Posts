//
//  PhotoRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-05.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData


class PhotoRepository {
    
    static let shared = PhotoRepository()
    
    func downloadPhotos(successHandler : @escaping ([Photo]) -> Void, failureHandler : @escaping (Error) -> Void){
        var photos : [Photo] = [Photo]()
        if let url : URL = URL(string: APIController.shared.usersAPI), APIController.shared.checkInternetAvalability(){
            APIController.shared.request(url: url) { (data) in
                do {
                    if let jsonRawData = data as? Data{
                        let jsonParsed = try JSONSerialization.jsonObject(with: jsonRawData, options: .allowFragments) as! [[String : AnyObject]]
                        photos = Mapper<Photo>().mapArray(JSONArray:jsonParsed)
                        APIController.shared.saveBatchInLocalStorage(photos) { (savedData) in
                            successHandler(photos)
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
    
    
    func selectAll(successHandler : @escaping ([Photo]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(Photo.fetchRequest()) as? [Photo]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
}
