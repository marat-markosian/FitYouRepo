//
//  ViewController.swift
//  FitYou
//
//  Created by Марат Маркосян on 29.05.2022.
//

import UIKit
import FirebaseAuth

class LogInVC: CustomVC {

    private lazy var emailTxt = CustomTxtField()
    private lazy var passwordTxt = CustomTxtField()
    private lazy var loginBtn = UIButton()
    
    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(emailTxt)
        view.addSubview(passwordTxt)
        view.addSubview(loginBtn)
        
        emailTxt.translatesAutoresizingMaskIntoConstraints = false
        passwordTxt.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
                
        loginBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.setTitle("Log In", for: .normal)
        loginBtn.addTarget(self, action: #selector(logIn), for: .touchUpInside)

        emailTxt.placeholder = "e-mail"
        passwordTxt.placeholder = "password"
        
        emailTxt.textContentType = .emailAddress
        passwordTxt.textContentType = .password
        emailTxt.keyboardType = .emailAddress
        passwordTxt.isSecureTextEntry = true
        
    }
    
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([            
            emailTxt.topAnchor.constraint(equalTo: cancelBtn.bottomAnchor, constant: 30),
            emailTxt.leadingAnchor.constraint(equalTo: cancelBtn.leadingAnchor),
            emailTxt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            emailTxt.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTxt.topAnchor.constraint(equalTo: emailTxt.bottomAnchor, constant: 30),
            passwordTxt.leadingAnchor.constraint(equalTo: emailTxt.leadingAnchor),
            passwordTxt.trailingAnchor.constraint(equalTo: emailTxt.trailingAnchor),
            passwordTxt.heightAnchor.constraint(equalToConstant: 40),
            
            loginBtn.topAnchor.constraint(equalTo: passwordTxt.bottomAnchor, constant: 50),
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }

}

extension LogInVC: LogInOperator {
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let result = authResult {
                self!.dismiss(animated: true)
            } else if let error = error {
                self?.showError(descr: error.localizedDescription)
            }
        }
    }
    
    
    @objc func logIn() {
        if let email = emailTxt.text, let password = passwordTxt.text {
            if password.count > 8 {
                login(email: email, password: password)
            } else {
                showError(descr: "Password should contain more then 8 characters")
            }
        }

    }
    
}
