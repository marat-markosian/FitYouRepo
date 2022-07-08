//
//  WorkoutCell.swift
//  FitYou
//
//  Created by Марат Маркосян on 27.05.2022.
//

import UIKit

class WorkoutCell: UICollectionViewCell {
    
    private lazy var name = CustomLabel()
    private lazy var priority = CustomLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setUpSubviews() {
        layer.cornerRadius = 5
        backgroundColor = .green
        
        addSubview(name)
        addSubview(priority)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        priority.translatesAutoresizingMaskIntoConstraints = false
        
        name.text = "Name"
        priority.text = "priority"
        
        name.font = UIFont(name: "Avenir-Heavy", size: 25)
        name.textColor = .label
        priority.font = UIFont(name: "Avenir", size: 15)
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: centerXAnchor),
            name.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
            priority.centerXAnchor.constraint(equalTo: centerXAnchor),
            priority.topAnchor.constraint(equalTo: name.bottomAnchor, constant: -5)
        ])
    }
    
    func setName(_ new: String) {
        name.text = new
    }
    
    func setPriority(_ new: String) {
        priority.text = "\(new) priority"
    }
    
}
