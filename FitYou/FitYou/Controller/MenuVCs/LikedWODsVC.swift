//
//  LikedWODsVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 08.06.2022.
//

import UIKit

class LikedWODsVC: WorkoutsVC {

    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        header.changeWOD(to: "Liked WODs")
        
        getLikedWODs()
        picker.isHidden = true
    }
    
    private func setUpAutoLayout() {
        workoutsCollection.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
    }
    
    func getLikedWODs() {
        var newwods: [[String : Any]] = []
        var IDs = [String]()
        wods = Server.instance.newwods
        docIDs = Server.instance.wodsID
        for index in 0 ..< wods.count {
            let usersID = wods[index]["whoLiked"] as! [String]
            for useriD in usersID {
                if useriD == Server.instance.userID {
                    newwods.append(wods[index])
                    IDs.append(docIDs[index])
                }
            }
        }
        wods = newwods
        docIDs = IDs
        workoutsCollection.reloadData()
    }
}
