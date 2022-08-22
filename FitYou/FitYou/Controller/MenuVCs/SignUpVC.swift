//
//  SignUpVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 30.05.2022.
//

import UIKit
import FirebaseAuth
import CoreData

class SignUpVC: CustomVC {
    
    private lazy var emailTxt = CustomTxtField()
    private lazy var passwordTxt = CustomTxtField()
    private lazy var signupBtn = UIButton()
    private lazy var genderSegment = UISegmentedControl(items: ["⚦", "♀"])
    private lazy var nameTxt = CustomTxtField()


    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(emailTxt)
        view.addSubview(passwordTxt)
        view.addSubview(signupBtn)
        view.addSubview(genderSegment)
        view.addSubview(nameTxt)
        
        emailTxt.translatesAutoresizingMaskIntoConstraints = false
        passwordTxt.translatesAutoresizingMaskIntoConstraints = false
        signupBtn.translatesAutoresizingMaskIntoConstraints = false
        genderSegment.translatesAutoresizingMaskIntoConstraints = false
        nameTxt.translatesAutoresizingMaskIntoConstraints = false
                
        signupBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        signupBtn.setTitleColor(.black, for: .normal)
        signupBtn.setTitle("Sign Up", for: .normal)
        signupBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)

        emailTxt.placeholder = "e-mail"
        passwordTxt.placeholder = "password"
        nameTxt.placeholder = "name"
        
        emailTxt.textContentType = .emailAddress
        passwordTxt.textContentType = .password
        emailTxt.keyboardType = .emailAddress
        passwordTxt.isSecureTextEntry = true
        
        genderSegment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
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
            
            genderSegment.widthAnchor.constraint(equalToConstant: 200),
            genderSegment.heightAnchor.constraint(equalToConstant: 30),
            genderSegment.centerXAnchor.constraint(equalTo: passwordTxt.centerXAnchor),
            genderSegment.topAnchor.constraint(equalTo: passwordTxt.bottomAnchor, constant: 30),
            
            nameTxt.topAnchor.constraint(equalTo: genderSegment.bottomAnchor, constant: 30),
            nameTxt.leadingAnchor.constraint(equalTo: passwordTxt.leadingAnchor),
            nameTxt.trailingAnchor.constraint(equalTo: passwordTxt.trailingAnchor),
            nameTxt.heightAnchor.constraint(equalToConstant: 40),
            
            signupBtn.topAnchor.constraint(equalTo: nameTxt.bottomAnchor, constant: 50),
            signupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])

    }
    
    @objc func segmentChanged() {
        if genderSegment.selectedSegmentIndex == 0 {
            genderSegment.selectedSegmentTintColor = .blue
        } else {
            genderSegment.selectedSegmentTintColor = .systemPink
        }
    }

}

extension SignUpVC: SaveCoreDataOperator {
    func saveGender(gender: String) {
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
      
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
      
        let userCore = NSManagedObject(entity: entity, insertInto: managedContext)
      
        userCore.setValue(gender, forKeyPath: "gender")
      
        do {
            try managedContext.save()
        } catch let error as NSError {
            showError(descr: error.localizedDescription)
        }
    }
}

extension SignUpVC: SignUpOperator {
    
    func signUpToServer(email: String, password: String, name: String, gender: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let result = authResult {
                
                let changeReq = Auth.auth().currentUser?.createProfileChangeRequest()
                changeReq?.displayName = name
                changeReq?.commitChanges() { error in
                    self.showError(descr: error?.localizedDescription ?? "Name was not saved")
                }
                
                self.saveGender(gender: gender)
                self.dismiss(animated: true)
            } else if let error = error {
                self.showError(descr: error.localizedDescription)
            }
        }
    }
    
    @objc func signUp() {
        
        if let email = emailTxt.text, let password = passwordTxt.text, let name = nameTxt.text {
            let genderNum = genderSegment.selectedSegmentIndex
            if genderNum == 0 {
                if password.count > 8 {
                    signUpToServer(email: email, password: password, name: name, gender: "Male")
                } else {
                    showError(descr: "Password should contain more then 8 characters")
                }
            } else if genderNum == 1 {
                if password.count > 8 {
                    signUpToServer(email: email, password: password, name: name, gender: "Female")
                } else {
                    showError(descr: "Password should contain more then 8 characters")
                }
            }
        }
        
    }
    
}
