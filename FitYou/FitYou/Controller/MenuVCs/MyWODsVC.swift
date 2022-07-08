//
//  MyWODsVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 09.06.2022.
//

import UIKit

class MyWODsVC: WorkoutsVC {


    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        header.changeWOD(to: "My WODs")
        
        picker.isHidden = true
        getMyWODs()
    }
    
    private func setUpAutoLayout() {
        workoutsCollection.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
    }
    
    func getMyWODs() {
        var newwods: [[String : Any]] = []
        var IDs = [String]()
        wods = Server.instance.newwods
        docIDs = Server.instance.wodsID
        
        for index in 0 ..< wods.count {
            let creator = wods[index]["creator"] as? String
            if creator == Server.instance.userID {
                newwods.append(wods[index])
                IDs.append(docIDs[index])
            }
        }
        wods = newwods
        docIDs = IDs
        workoutsCollection.reloadData()
    }

}
