//
//  User.swift
//  MIST
//
//  Created by Muhammad Doukmak on 2/4/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    
    let email: String
    let uid: String
    
    init(data: FIRUser) {
        uid = data.uid
        email = data.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
