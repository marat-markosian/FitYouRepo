//
//  Server.swift
//  FitYou
//
//  Created by Марат Маркосян on 28.05.2022.
//

import UIKit
import FirebaseFirestore

struct Server {
    
    static var instance = Server()
    
    let data = Firestore.firestore()
    
    var userDisplayName = ""
    var userID = ""
    var wodsWithMyResult: [[String : Any]] = []
    
    var newwods: [[String : Any]] = [
        [
        "name": "Detail",
        "priority": "Task",
        "exercises": ["pull-ups", "air squats", "chin-ups", "push-ups", "toe-to-bar", "walking lunges", "dips"],
        "repetitions": [10, 10, 10, 10, 10, 10, 10],
        "setsORtime": 5,
        "whoLiked": [],
        "whoAddedResultIDs": [],
        "names": [],
        "results": []
        ],
        [
        "name": "Anderson",
        "priority": "Time",
        "exercises": ["burpees", "push-ups", "sit-ups", "air squats"],
        "repetitions": [5, 10, 15, 20],
        "setsORtime": 20,
        "whoLiked": [],
        "whoAddedResultIDs": [],
        "names": [],
        "results": []
        ]
    ]
    
    var wodsID: [String] = ["gjKD5yMx4MebEuv5sJGw", "iclDg39GTmTW7FfUHifX"]
    
    func getWODs() {
        data.collection("WODs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                var reloadData: [[String: Any]] = []
                var reloadID: [String] = []
                for document in querySnapshot!.documents {
                    reloadData.append(document.data())
                    reloadID.append(document.documentID)
                }
                Server.instance.newwods = reloadData
                Server.instance.wodsID = reloadID
            }
        }
    }

}
