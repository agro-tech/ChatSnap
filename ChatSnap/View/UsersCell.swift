//
//  UsersCell.swift
//  ChatSnap
//
//  Created by Alan Ramos on 7/14/18.
//  Copyright © 2018 Alan Ramos. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {

    @IBOutlet weak var firstNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCheckmarK(selected: false)
    }
    
    func updateUI(user: User) {
        firstNameLbl.text = user.firstName
    }

    func setCheckmarK(selected: Bool) {
        let imageStrg = selected ? "messageindicatorchecked1" : "messageindicator1"
        self.accessoryView = UIImageView(image: UIImage (named: imageStrg))
    }
}
