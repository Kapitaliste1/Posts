//
//  PostTableViewController.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {

    var postArray : [Post]?
    var usersArray : [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.getPosts()
    }
    

}


//MARK: - Table view Management
extension PostTableViewController {
    
    fileprivate func registerCells()
    {
        let cell = UINib(nibName: PostTableViewCell.identifier, bundle:nil)
        self.tableView.register(cell,forCellReuseIdentifier: PostTableViewCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postArray?.count ?? 0
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell {
            if let post = self.postArray?[indexPath.row]{
                cell.post = post
                if let postOwner = self.usersArray?.filter({ $0.id == post.userId }), !postOwner.isEmpty{
                    cell.user = postOwner.first
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
}


//MARK: - Data Retrieval
extension PostTableViewController {
    fileprivate func getPosts() {
        PostRepository.shared.retrievePosts { (postsData) in
            if let posts = postsData, !posts.isEmpty {
                self.postArray = posts
                self.getUsers { (result) in
                    if result {
                        self.tableView.reloadData()
                    }else{
                        self.prensentFailedAlertToReload()
                    }
                }
            }else{
                self.prensentFailedAlertToReload()
            }
        }
    }
    
    fileprivate func getUsers(completed : @escaping (Bool) -> Void) {
        UserRepository.shared.retrieveUser { (usersData) in
            if let users = usersData, !users.isEmpty {
                self.usersArray = users
                completed(true)
            }else{
                completed(false)
            }
        }
    }
    
}


//MARK: - Alert view
extension PostTableViewController {
    fileprivate func prensentFailedAlertToReload(){
        let alertController = UIAlertController(title: "Alert", message: "We are facing troubles to load the data, please dismiss this alert to retry.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Dismiss", style: .destructive) { (action:UIAlertAction) in
            self.getPosts()
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
}
