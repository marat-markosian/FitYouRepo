//
//  Server.swift
//  FitYou
//
//  Created by Марат Маркосян on 28.05.2022.
//

import Foundation
import FirebaseCore
import UIKit

struct Server {
    
    static var instance = Server()
    
    var userDisplayName = ""
    var userID = ""
    var wodsWithMyResult: [[String : Any]] = []
    
    var newwods: [[String : Any]] = [
        [
        "name": "Detail",
        "priority": "Task",
        "exercises": ["pull-ups", "air squats", "chin-ups", "push-ups", "toe-to-bar", "walking lunges", "dips"],
        "repetitions": [10, 10, 10, 10, 10, 10, 10],
        "setsORtime": 5],
        [
        "name": "Anderson",
        "priority": "Time",
        "exercises": ["burpees", "push-ups", "sit-ups", "air squats"],
        "repetitions": [5, 10, 15, 20],
        "setsORtime": 20
        ]
    ]
    
    var wodsID: [String] = []
    
}
