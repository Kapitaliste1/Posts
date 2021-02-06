//
//  AddressRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

class AddressRepository {
    
    static let shared = AddressRepository()
    
    func downloadAddress(jsonDictionnary :[String : Any]){
        if var addressJson =  jsonDictionnary["address"] as? [String: Any], let id = jsonDictionnary["id"] as? Int16{
            addressJson["userId"] = id
            var addressArray : [Address] = [Address]()
            addressArray = Mapper<Address>().mapArray(JSONArray:[addressJson])
            APIController.shared.saveBatchInLocalStorage(addressArray) { (savedData) in
            } failureHandler: { (_) in
            }
        }
    }
     
    
    func selectAll(successHandler : @escaping ([Address]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(Address.fetchRequest()) as? [Address]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
    
    func selectByUserId(userId : Int16,successHandler : @escaping (Address) -> Void, failureHandler : @escaping (Error) -> Void) {
        let fetchRequest = Address.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "userId == %d", userId)
        
        do {
            if let array = try managedContext.fetch(fetchRequest) as? [Address], let item = array.first{
                successHandler(item)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
        
    }
    
    
}
