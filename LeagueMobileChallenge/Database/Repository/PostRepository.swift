//
//  PostRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//

import Foundation
import ObjectMapper

class PostRepository {
    
    static let shared = PostRepository()
    
    func downloadPosts(successHandler : @escaping ([Post]) -> Void, failureHandler : @escaping (Error) -> Void){
        var posts : [Post] = [Post]()
        if let url : URL = URL(string: APIController.shared.postsAPI), APIController.shared.checkInternetAvalability(){
            APIController.shared.request(url: url) { (data) in
                do {
                    if let jsonRawData = data as? Data{
                        let jsonParsed = try JSONSerialization.jsonObject(with: jsonRawData, options: .allowFragments) as! [[String : AnyObject]]
                        posts = Mapper<Post>().mapArray(JSONArray:jsonParsed)
                        APIController.shared.saveBatchInLocalStorage(posts) { (savedData) in
                            successHandler(posts)
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
    
    
    func selectAll(successHandler : @escaping ([Post]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(Post.fetchRequest()) as? [Post]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
}
