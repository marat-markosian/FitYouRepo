//
//  SectionButton.swift
//  FitYou
//
//  Created by Марат Маркосян on 27.05.2022.
//

import UIKit

class SectionButton: UIButton {
    
    lazy var sectionName = UILabel()

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
        
        addSubview(sectionName)
        sectionName.translatesAutoresizingMaskIntoConstraints = false
        
        sectionName.font = UIFont(name: "Avenir-Heavy", size: 35)
        sectionName.text = "Section"
        
        sectionName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sectionName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setUpSectionName(to name: String) {
        sectionName.text = name
    }
    
}
