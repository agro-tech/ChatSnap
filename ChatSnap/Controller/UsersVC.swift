//
//  UsersVC.swift
//  ChatSnap
//
//  Created by Alan Ramos on 7/14/18.
//  Copyright © 2018 Alan Ramos. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!

    
    private var users = [User]()
    private var selectedUsers = Dictionary<String, User>()
    
    private var _snapData: Data?
    private var _videoURL: URL?
    
    var snapData: Data? {
        set {
            _snapData = newValue
        } get {
           return _snapData
        }
    }
    
    var videoURL: URL? {
        set {
            _videoURL = newValue
        } get {
            return _videoURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DataService.instance.usersRef.observeSingleEvent (of: .value) { (snapshot: DataSnapshot) in
            
            print("Snap: \(snapshot.debugDescription)")
            
            if let users = snapshot.value as? Dictionary<String, Any> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, Any> {
                        if let profile  = dict["profile"] as? Dictionary<String , Any> {
                            if let firstName = profile ["firstName"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UsersCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UsersCell
        cell.setCheckmarK(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UsersCell
        cell.setCheckmarK(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count <= 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    @IBAction func sendPRBtnPressed(sender: Any) {
        if let url = _videoURL {
            let videoName = "\(NSUUID().uuidString)\(url)"
            let ref = DataService.instance.videoStorageRef.child(videoName)
            
            
            _ = ref.putFile(from: url, metadata: nil, completion: { (meta: StorageMetadata?, err: Error?) in
                if err != nil {
                    print("Error Uploading Video: \(String(describing: err?.localizedDescription))")
                } else {
                    let downloadURL = ref.downloadURL(){ (url, error) in
                        if err != nil {

                        }else {
                        }
                    }
                    DataService.instance.sendMediaPullRequest(senderUID: Auth.auth().currentUser!.uid, sendingTo: self.selectedUsers, mediaURL: downloadURL as URL, textSnippet: "Coding today was LEGIT!")
                }
            })
            self.dismiss(animated: true, completion: nil)

        } else if let snap = _snapData {
            let ref = DataService.instance.imagesStorageRef.child("\(NSUUID().uuidString).jpg")
            
            _ = ref.putData(snap, metadata: nil, completion: { (meta:StorageMetadata?, err: Error?) in
                
                if err != nil {
                    print("Error uploading snapshot: \(String(describing: err?.localizedDescription))")
                } else {
                    _ = ref.downloadURL(completion: { (url, error) in
                        if err != nil {
                            
                        }else {
                            
                        }
                    })
                }
            })
            self.dismiss(animated: true, completion: nil)

        }
    
    }

    
}

