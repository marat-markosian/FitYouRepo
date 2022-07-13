//
//  PopularWODsVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 13.07.2022.
//

import UIKit

class PopularWODsVC: WorkoutsVC {

    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPopularWODs()
    }
    
    private func setUpSubviews() {
        picker.isHidden = true
        
        header.changeWOD(to: "Popular Workouts")
    }
    
    private func setUpAutoLayout() {
        workoutsCollection.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
    }
    
    private func getPopularWODs() {
        var newwods: [[String : Any]] = []
        var IDs = [String]()
        wods = Server.instance.newwods
        docIDs = Server.instance.wodsID
        for index in 0 ..< wods.count {
            let likes = wods[index]["whoLiked"] as! [String]
            if likes.count > 0 {
                newwods.append(wods[index])
                IDs.append(docIDs[index])
            }
        }
        wods = newwods
        docIDs = IDs
        workoutsCollection.reloadData()
    }
}
