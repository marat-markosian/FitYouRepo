//
//  CustomHeader.swift
//  FitYou
//
//  Created by Марат Маркосян on 23.06.2022.
//

import UIKit

class CustomHeader: UITableViewHeaderFooterView {

    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(equalToConstant: 15),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }

}
