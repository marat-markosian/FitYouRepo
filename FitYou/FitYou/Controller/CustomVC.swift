//
//  CustomVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 16.08.2022.
//

import UIKit

class CustomVC: UIViewController {

    lazy var cancelBtn = UIButton()
    lazy var backBtn = UIButton()
    
    override func loadView() {
        super.loadView()
        
        setButtons()
    }

    func setButtons() {
        
        view.addSubview(cancelBtn)
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false

        backBtn.setBackgroundImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.tintColor = .black
        backBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        cancelBtn.setTitleColor(.red, for: .normal)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        cancelBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cancelBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true

    }
    
    func showError(descr: String) {
        let alert = UIAlertController(title: "Error", message: descr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }

    @objc private func dismissAction() {
        dismiss(animated: true)
    }

}
