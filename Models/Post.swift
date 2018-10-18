//
//  Post.swift
//  Post
//
//  Created by Arkin Hill on 10/15/18.
//  Copyright © 2018 Arkin Hill. All rights reserved.
//

import Foundation

struct Post: Codable {
    let text: String
    let timestamp: TimeInterval
    let username: String
    
    init(text: String, username: String) {
        self.text = text
        self.username = username
        self.timestamp = Date().timeIntervalSince1970
    }
    
    var asData: Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            print("Error decoding")
        }
        return Data()
    }
}

