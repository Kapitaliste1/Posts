//
//  UserRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//

import Foundation
import ObjectMapper
import CoreData

class UserRepository {
    
    static let shared = UserRepository()
    
    func downloadUser(successHandler : @escaping ([User]) -> Void, failureHandler : @escaping (Error) -> Void){
        var users : [User] = [User]()
        if let url : URL = URL(string: APIController.shared.usersAPI), APIController.shared.checkInternetAvalability(){
            APIController.shared.request(url: url) { (data) in
                do {
                    if let jsonRawData = data as? Data{
                        let jsonParsed = try JSONSerialization.jsonObject(with: jsonRawData, options: .allowFragments) as! [[String : AnyObject]]
                        users = Mapper<User>().mapArray(JSONArray:jsonParsed)
                        APIController.shared.saveBatchInLocalStorage(users) { (savedData) in
                            successHandler(users)
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
    
    
    
    
    func selectAll(successHandler : @escaping ([User]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(User.fetchRequest()) as? [User]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
    
    func selectById(id : Int16,successHandler : @escaping (User) -> Void, failureHandler : @escaping (Error) -> Void) {
        let fetchRequest = User.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
 
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

 
         do {
            if let array = try managedContext.fetch(fetchRequest) as? [User], let item = array.first{
                successHandler(item)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
        
    }
    
    
}
