//
//  CustomLabel.swift
//  FitYou
//
//  Created by Марат Маркосян on 27.05.2022.
//

import UIKit

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setUpLabel() {
        textColor = .black
        font = UIFont(name: "Avenir", size: 20)
    }
    
}
