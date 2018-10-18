//
//  PostListTableViewController.swift
//  Post
//
//  Created by Arkin Hill on 10/15/18.
//  Copyright © 2018 Arkin Hill. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    // MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        
        PostController.shared.getPosts { (success) in
            if success {
                self.reloadTableView()
            }
        }
    }
    
    // MARK: - ACTIONS
    
    // This action is user pulling down to refresh.
    @IBAction func refreshControl(_ sender: Any) {
        
        // When that action happens, we show the network activitiy indicator in status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Now we call "getPosts" and create array of new posts
        PostController.shared.getPosts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.reloadTableView()
                }
            } else {
                return
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        // Set up alert controler (title, message, style)
        let alertController = UIAlertController(title: "Add Post", message: "Enter a new post here", preferredStyle: .alert)
        
        alertController.addTextField { (userNameTextField) in
            userNameTextField.placeholder = "Your username"
        }
        
        // Add placeholder to alert field
        alertController.addTextField { (textField) in
            textField.placeholder = "New post"
        }
        
        // Set up creat button
        let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            
            // Check to see if field has tex
            guard let username = alertController.textFields?.first?.text,
                !username.isEmpty,
                let text = alertController.textFields?.last?.text,
                !text.isEmpty else { return }
            
            
            // Call create function
            PostController.shared.postPosts(text: text, username: username, completion: { (success) in
                if success {
                    self.reloadTableView()
                }
            })
        }
        
        // Set up "Cancel" button in alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        // Complete "create" or "cancel" in alert controller
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - TABLE VIEW SOURCE
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = PostController.shared.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username), \(post.timestamp)"
        
        return cell
    }
    
    // MARK: - RELOAD TABLE VIEW
    
    func reloadTableView() {  // INCOMPLETE
        
        DispatchQueue.main.async {
            // When that action happens, we show the network activitiy indicator in status bar
            self.tableView.reloadData()
            
            // Turn it off
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

