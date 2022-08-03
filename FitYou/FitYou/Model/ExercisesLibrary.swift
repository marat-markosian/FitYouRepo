//
//  ExercisesLibrary.swift
//  FitYou
//
//  Created by Марат Маркосян on 22.06.2022.
//

import Foundation

struct ExercisesLibrary {

    static var instance = ExercisesLibrary()
    
    var exercisesToAdd: [String] = []
    var repetitionsToAdd: [Int] = []
    
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    
    let exercisesDict : [String : [String]] = [
        "A" : ["air squat", "air bike"],
        "B" : ["back squat", "bear crawl", "bench press", "box steps", "box jump", "burpee", "butterfly pull-ups"],
        "C" : ["concept II rowing machine", "chest to bar pull-ups", "clean", "clean & jerk"],
        "D" : ["dead bug", "dip", "death lift", "double-unders", "dumbbell"],
        "E" : [],
        "F" : ["front squat", "false grip", "floor wipes"],
        "G" : ["glute-ham developer", "goblet squat"],
        "H" : ["hammer slam", "handstand push-up", "hang power clean", "hang power snatch", "hip thrust", "hollow rock", "hook grip", "hang power clean", "hand stand walk", "hyperextension"],
        "I" : [],
        "J" : ["jerk", "jumping jacks"],
        "K" : ["kettlebell", "knees to elbows", "kettlebell swing", "kipping pull-ups"],
        "L" : ["L-hold", "L-pull-up", "lunges"],
        "M" : ["medicine ball", "medicine ball cleans", "metCon", "military press", "muscle-up"],
        "N" : [],
        "O" : ["overhead squat"],
        "P" : ["power snatch", "plank", "plyo push-up", "power clean", "push jerk", "push press", "pull-ups", "push-ups"],
        "Q" : [],
        "R" : ["reverse crunch", "reverse row", "ring dips", "rope climb", "(m) run"],
        "S" : ["sumo dead lift high pull", "sit up", "slam ball", "snatch", "snatch balance", "shoulder press", "strict pull-ups", "squat", "squat clean", "squat snatch", "swing"],
        "T" : ["toes to bar", "tabata squat", "thrusters", "turkish get-up"],
        "U" : [],
        "V" : [],
        "W" : ["walking lunges", "wall ball", "wall walk"],
        "X" : [],
        "Y" : [],
        "Z" : []
    ]
}
