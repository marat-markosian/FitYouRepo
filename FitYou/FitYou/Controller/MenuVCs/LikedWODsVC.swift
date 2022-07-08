//
//  LikedWODsVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 08.06.2022.
//

import UIKit
import FirebaseFirestore

class LikedWODsVC: WorkoutsVC {

    override func loadView() {
        super.loadView()
        
        getLikedWODs()
        setUpSubviews()
        setUpAutoLayout()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Server.instance.getWODs()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getLikedWODs()
    }
    
    private func setUpSubviews() {
        header.changeWOD(to: "Liked WODs")
        
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
