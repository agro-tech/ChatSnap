//
//  AuthService.swift
//  ChatSnap
//
//  Created by Alan Ramos on 5/8/18.
//  Copyright © 2018 Alan Ramos. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    if errorCode  == .userNotFound {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            } else {
                                if user?.user.uid != nil {
                                    DataService.instance.saveUser(uid: (user?.user.uid)!)
                                    //Sign In
                                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil {
                                            //Show Error to User
                                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                            
                                        }else {
                                            onComplete?(nil, user)
                                        }
                                    })
                                }
                            }
                        })
                    }
                } else {
                    //Handle all other errors
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                }
            } else {
                //Successfully Logged in
                onComplete?(nil, user)
            }
            
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .invalidEmail: onComplete? ("Invalid email address", nil)
                break
            case .wrongPassword: onComplete?("Invalid password", nil)
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential: onComplete?("Email already taken", nil)
                 break
            
            default: onComplete?("There was a problem authenticating. Try again", nil)
                
            }
        }
    }
}
