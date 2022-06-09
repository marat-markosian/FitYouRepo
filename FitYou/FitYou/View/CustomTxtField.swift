//
//  CustomTxtField.swift
//  FitYou
//
//  Created by Марат Маркосян on 29.05.2022.
//

import UIKit

class CustomTxtField: UITextField {

    lazy var border = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        underlined(color: UIColor(red: 104/255, green: 240/255, blue: 135/255, alpha: 1))
        font = UIFont(name: "Avenir", size: 19)
        textColor = .black
        attributedPlaceholder = NSAttributedString(string: "",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func changeLineColor(_ color: UIColor) {
        border.backgroundColor = color
    }
    
    func underlined(color: UIColor) {
        borderStyle = .none
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        addSubview(border)
        border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 3).isActive = true
        border.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        border.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

}

extension CustomTxtField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }

}
