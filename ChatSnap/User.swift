//
//  User.swift
//  ChatSnap
//
//  Created by Alan Ramos on 7/14/18.
//  Copyright © 2018 Alan Ramos. All rights reserved.
//

import UIKit

struct User {
    private var _firstName: String
    private var _uid: String

    
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        return _firstName
    }
    
    init(uid: String, firstName: String) {
        _uid = uid
        _firstName = firstName
    }
}
