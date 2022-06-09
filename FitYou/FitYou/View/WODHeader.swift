//
//  WODHeader.swift
//  FitYou
//
//  Created by Марат Маркосян on 27.05.2022.
//

import UIKit

class WODHeader: UIView {
    
    lazy var wodLabel = CustomLabel()
    private lazy var name = CustomLabel()
    private lazy var priority = CustomLabel()
    
    let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setUpSubviews() {
        backgroundColor = .white
        
        wodLabel.text = "WOD"
        wodLabel.font = UIFont(name: "Avenir-Heavy", size: 35)
        wodLabel.numberOfLines = 0
        name.text = "Name"
        name.font = UIFont(name: "Avenir", size: 30)
        priority.text = "priority"
        priority.font = UIFont(name: "Avenir", size: 15)
        priority.textColor = .lightGray
        
        addSubview(stack)
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 0
        stack.addArrangedSubview(wodLabel)
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(priority)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    func setUpName(_ toName: String) {
        name.text = toName
    }
    
    func setUpPriority(_ toPriority: String) {
        priority.text = "\(toPriority) priority"
    }
    
    func changeWOD(to new: String){
        wodLabel.text = new
    }
    
    func hideName() {
        name.isHidden = true
    }
    
    func hidePriority() {
        priority.isHidden = true
    }
    
    
}
