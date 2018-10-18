//
//  PostController.swift
//  Post
//
//  Created by Arkin Hill on 10/15/18.
//  Copyright © 2018 Arkin Hill. All rights reserved.
//

import Foundation

// MARK: - CLASS, SHARED, TRUTH

class PostController: Codable {
    
    // Shared instance
    static let shared = PostController()
    
    // Source of truth
    var posts: [Post] = []
    
    // MARK: - BASE URL
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    // MARK: - GET POSTS FUNCTION (URL & DATA TASK)
    
    func getPosts(completion: @escaping (Bool) -> Void) {
        
        //A - URL
        
        // A1 - Full URL (Add paths component and extension to base URL)
        guard let fullURL = baseURL?.appendingPathExtension("json") else {
            print("Error getting the right URL")
            completion(false)
            return
        }
        
        // A2 - URL request "request" to be used in function - Full URL + HTTP method and body
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // B - Data Task
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            // B1 - When we can't get data
            if let error = error {
                print("There was an error retrieving the data from the endpoint: \(error.localizedDescription).", #function)
                completion(false)
                return
            }
            
            // B2 - When there's no data in data (need to unwrap)
            guard let data = data else {
                print("there was no data")
                completion(false)
                return
            }
            
            // B3 - When there is data (the DO is for good data, the CATCH is for bad)
            let decoder = JSONDecoder()
            do {
                let postsDictionaries = try decoder.decode([String: Post].self, from: data)
                var posts = [Post]()
                for (_, value) in postsDictionaries {
                    posts.append(value)
                }
                self.posts = posts
                completion(true)
            } catch {
                print("There was an error decoding the data: \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        // after everything is finished, you need to resume
        dataTask.resume()
    }
    
    // MARK: - POST POSTS
    
    func postPosts(text: String, username: String,completion: @escaping (Bool) -> Void) {
        
        // A - URL
        
        // A1 - Full URL
        guard let fullURL = baseURL?.appendingPathExtension("json") else {
            print("Error getting the right URL")
            completion(false)
            return
        }
        
        let newPost = Post(text: text, username: username)
        
        // A2 - URL request "request" to be used in function - Full URL + HTTP method and body
        var request = URLRequest(url: fullURL)
        request.httpMethod = "POST"
        request.httpBody = newPost.asData
        
        // B - Data Task
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            // B1 - When we can't get data
            if let error = error {
                print("There was an error retrieving the data from the endpoint: \(error.localizedDescription).", #function)
                completion(false)
                return
            }

            // B2 - When we successfully post a person (Send new people arraty back to data on web
            PostController.shared.posts.append(newPost)
            completion(true)
            
        }
        // Don't forget to call "resume"
        dataTask.resume()
    }
}
