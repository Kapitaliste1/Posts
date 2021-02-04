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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        
        PostRepository.shared.retrievePosts { (postsData) in
            if let posts = postsData, !posts.isEmpty {
                self.postArray = posts
                self.tableView.reloadData()
            }else{
                self.prensentFailedAlertToReload()
            }
        }
         
    }
    
    func registerCells()
    {
        let cell = UINib(nibName: PostTableViewCell.identifier, bundle:nil)
        self.tableView.register(cell,forCellReuseIdentifier: PostTableViewCell.identifier)
    }
    
    func prensentFailedAlertToReload(){
        let alertController = UIAlertController(title: "Alert", message: "We are facing troubles to load the data, please dismiss this alert to retry.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Dismiss", style: .destructive) { (action:UIAlertAction) in
            PostRepository.shared.retrievePosts { (postsData) in
                if let posts = postsData, !posts.isEmpty {
                    self.postArray = posts
                    self.tableView.reloadData()
                }else{
                    self.prensentFailedAlertToReload()
                }
            }
        }
        
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }

}


//
extension PostTableViewController {
    // MARK: - Table view data source
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
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
