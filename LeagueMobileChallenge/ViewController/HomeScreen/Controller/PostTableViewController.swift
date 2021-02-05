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
    var albumsArray : [Album]?
    
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
                cell.delegate = self
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
            self.postArray = postsData
            self.getUsers {
                self.getAlbums {
                    self.tableView.reloadData()
                }
            }
        } failureHandler: { (error) in
            let alertController =  self.prensentFailedAlert(error: error) {
                self.getPosts()
            }
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    fileprivate func getUsers(completed : @escaping () -> Void) {
        UserRepository.shared.retrieveUser(successHandler: { (usersData) in
            self.usersArray = usersData
            completed()
        }, failureHandler: { (error) in
            let alertController = self.prensentFailedAlert(error: error) {}
            self.present(alertController, animated: true, completion: nil)
            completed()
        })
    }
    
    fileprivate func getAlbums(completed : @escaping () -> Void){
        AlbumRepository.shared.retrieveAlbums { (albumsData) in
            self.albumsArray = albumsData
            completed()
        } failureHandler: { (error) in
            let alertController = self.prensentFailedAlert(error: error) {}
            self.present(alertController, animated: true, completion: nil)
            completed()
        }
    }
    
}


//MARK: - User detail navigation delegate from PostTableViewCell
extension PostTableViewController : PostTableViewCellProtocol{
    func showUserDetail(user: User) {
        if let userDetailVC = self.navigateTo(storyboard: .UserDetail) as? UserDetailsViewController,
           let currentUserAlbum = self.albumsArray?.filter({ $0.userId == user.id}){
            userDetailVC.user = user
            userDetailVC.albumArray = currentUserAlbum
            self.navigationController?.show(userDetailVC, sender: self)
        }
    }
}
