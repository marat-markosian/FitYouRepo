//
//  Server.swift
//  FitYou
//
//  Created by Марат Маркосян on 28.05.2022.
//

import Foundation

struct Server {
    
    static let instance = Server()
    
    let wods: [WODModel] = [
        WODModel(name: "Detail", priority: "Task", exercises: ["10 pull-ups", "10 air squats", "10 chin-ups", "10 push-ups", "10 toe-to-bar", "10 walking lunges", "10 dips"], time: nil, sets: 5),
        WODModel(name: "Anderson", priority: "Time", exercises: ["5 burpees", "10 push-ups", "15 sit-ups", "20 air squats"], time: 20, sets: nil)
    ]
    
}
