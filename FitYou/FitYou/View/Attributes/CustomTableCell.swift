//
//  ExerciseCell.swift
//  FitYou
//
//  Created by Марат Маркосян on 27.05.2022.
//

import UIKit

class CustomTableCell: UITableViewCell {
    
    private lazy var exerciseName = CustomLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }

    private func setUpSubviews() {
        addSubview(exerciseName)
        backgroundColor = .white
        exerciseName.text = "exercise"
        exerciseName.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        exerciseName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }

    func setNameAndRep(_ name: String, repetitions: Int) {
        exerciseName.text = "\(repetitions) \(name)"
    }
    
    func setName(_ name: String) {
        exerciseName.text = name
    }
    
    
}
