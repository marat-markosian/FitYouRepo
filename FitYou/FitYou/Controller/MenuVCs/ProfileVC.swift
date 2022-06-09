//
//  ProfileVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 02.06.2022.
//

import UIKit
import CoreData

class ProfileVC: UIViewController {

    private lazy var cancelBtn = UIButton()
    private lazy var nameLbl = CustomLabel()
    private lazy var genderLbl = UILabel()
    private lazy var changeEmailBtn = UIButton()
    private lazy var changePasswordBtn = UIButton()
    private lazy var saveBtn = UIButton()
    private lazy var emailPasswordTxt = CustomTxtField()
    
    var userGender : [NSManagedObject] = []

    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
     func fetchGender() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
            
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
      
          do {
              let user = try managedContext.fetch(fetchRequest)
              userGender = user
          } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
          }
     }
    
    private func setUpSubviews() {
        view.backgroundColor = .white
        view.addSubview(cancelBtn)
        view.addSubview(saveBtn)
        view.addSubview(nameLbl)
        view.addSubview(genderLbl)
        view.addSubview(changeEmailBtn)
        view.addSubview(changePasswordBtn)
        
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        genderLbl.translatesAutoresizingMaskIntoConstraints = false
        changeEmailBtn.translatesAutoresizingMaskIntoConstraints = false
        changePasswordBtn.translatesAutoresizingMaskIntoConstraints = false
        
        cancelBtn.setTitleColor(.red, for: .normal)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(.blue, for: .normal)
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.isHidden = true
        
        nameLbl.text = Server.instance.userDisplayName
        nameLbl.font = UIFont(name: "Avenir-Heavy", size: 30)
        
        genderLbl.textColor = .lightGray
        fetchGender()
        if userGender.isEmpty {
            genderLbl.text = "Male/Female"
        } else {
            genderLbl.text = userGender[0].value(forKey: "gender") as? String
        }
        
        changeEmailBtn.setTitle("Change e-mail", for: .normal)
        changeEmailBtn.setTitleColor(.black, for: .normal)
        changeEmailBtn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                
        changePasswordBtn.setTitle("Change password", for: .normal)
        changePasswordBtn.setTitleColor(.black, for: .normal)
        changePasswordBtn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            cancelBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cancelBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cancelBtn.heightAnchor.constraint(equalTo: saveBtn.heightAnchor),
            
            saveBtn.topAnchor.constraint(equalTo: cancelBtn.topAnchor),
            saveBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            nameLbl.topAnchor.constraint(equalTo: cancelBtn.bottomAnchor, constant: 10),
            nameLbl.leadingAnchor.constraint(equalTo: cancelBtn.leadingAnchor),
            
            genderLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 5),
            genderLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            
            changeEmailBtn.heightAnchor.constraint(equalToConstant: 50),
            changeEmailBtn.topAnchor.constraint(equalTo: genderLbl.bottomAnchor, constant: 60),
            changeEmailBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            changePasswordBtn.heightAnchor.constraint(equalToConstant: 30),
            changePasswordBtn.topAnchor.constraint(equalTo: changeEmailBtn.bottomAnchor, constant: 50),
            changePasswordBtn.centerXAnchor.constraint(equalTo: changeEmailBtn.centerXAnchor)
                                    
        ])
        
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        saveBtn.isHidden = false
        
        if sender.currentTitle == "Change e-mail" {
            changePasswordBtn.isHidden = true
            emailPasswordTxt.placeholder = "print new e-mail"
        }
        
        if sender.currentTitle == "Change password" {
            changeEmailBtn.isHidden = true
            emailPasswordTxt.placeholder = "print new password"
        }

        UIView.transition(from: sender,
                          to: emailPasswordTxt,
                          duration: 1) { _ in
            self.emailPasswordTxt.translatesAutoresizingMaskIntoConstraints = false
            self.emailPasswordTxt.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.emailPasswordTxt.topAnchor.constraint(equalTo: self.genderLbl.bottomAnchor, constant: 60).isActive = true
            self.emailPasswordTxt.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            self.emailPasswordTxt.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        }
        
        
    }
    
}

