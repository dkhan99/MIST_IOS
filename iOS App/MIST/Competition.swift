//
//  Competition.swift
//  MIST
//
//  Created by Muhammad Doukmak on 2/4/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Competition {
    
    let name: String
    let ref: FIRDatabaseReference?
    let locationArray:[[String:Any]]
    
    init(name: String, locationArray: [[String:Any]]) {
        self.name = name
        self.locationArray = locationArray
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        name = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        locationArray = snapshotValue["locationArray"] as! [[String:Any]]
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "locationArray": locationArray
        ]
    }
    
}
