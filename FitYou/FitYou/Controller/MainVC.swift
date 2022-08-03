//
//  ViewController.swift
//  FitYou
//
//  Created by Марат Маркосян on 26.05.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class MainVC: UIViewController {
    
    private lazy var header = WODHeader()
    private lazy var userBtn = UIButton()
    private lazy var workoutsBtn = SectionButton()
    private lazy var addWorkoutBtn = SectionButton()
    private lazy var popularWorkoutsBtn = SectionButton()
    private lazy var exercisesBtn = SectionButton()
    
    let btnsStack = UIStackView()
    var handle = NSObject()
    
    let wodForHead = Server.instance.newwods[0]
        
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                Server.instance.userDisplayName = user.displayName ?? ""
                Server.instance.userID = user.uid
                self.changeImageAndAction(true)
            } else {
                self.changeImageAndAction(false)
            }
        } as! NSObject
        Server.instance.getWODs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    private func setUpSubviews() {
        view.addSubview(header)
        header.addSubview(userBtn)
        view.addSubview(btnsStack)
        setUpUserBtn()
        
        header.translatesAutoresizingMaskIntoConstraints = false
        userBtn.translatesAutoresizingMaskIntoConstraints = false
                
        let tapHead = UITapGestureRecognizer(target: self, action: #selector(goToHeadWOD))
        
        header.changeWOD(to: "Workout of the Day")
        header.setUpName(wodForHead["name"] as! String)
        header.setUpPriority(wodForHead["priority"] as! String)
        header.stack.isUserInteractionEnabled = true
        header.stack.addGestureRecognizer(tapHead)
        
        //Section Buttons
        workoutsBtn.setUpSectionName(to: "Workouts")
        addWorkoutBtn.setUpSectionName(to: "Add Workout")
        popularWorkoutsBtn.setUpSectionName(to: "Popular Workouts")
        exercisesBtn.setUpSectionName(to: "Exercises")
        
        workoutsBtn.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
        popularWorkoutsBtn.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
        exercisesBtn.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
        addWorkoutBtn.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)

        
        btnsStack.translatesAutoresizingMaskIntoConstraints = false
        btnsStack.axis = .vertical
        btnsStack.distribution = .fillEqually
        btnsStack.alignment = .fill
        btnsStack.spacing = 10
        
        btnsStack.addArrangedSubview(workoutsBtn)
        btnsStack.addArrangedSubview(addWorkoutBtn)
        btnsStack.addArrangedSubview(popularWorkoutsBtn)
        btnsStack.addArrangedSubview(exercisesBtn)
        
    }
    
    func setUpUserBtn() {
        userBtn.tintColor = .black
        userBtn.showsMenuAsPrimaryAction = true

    }
    
    func changeImageAndAction(_ isLogged: Bool) {
        
        let logIn = UIAction(title: "Log In") { _ in
            let log = LogInVC()
            log.modalPresentationStyle = .fullScreen
            self.present(log, animated: true)
        }
        
        let signUp = UIAction(title: "Sign Up") { _ in
            let sign = SignUpVC()
            sign.modalPresentationStyle = .fullScreen
            self.present(sign, animated: true)
        }
        
        let profile = UIAction(title: "Profile") { _ in
            let prof = ProfileVC()
            prof.modalPresentationStyle = .fullScreen
            self.present(prof, animated: true)
        }
        
        let likedWOD = UIAction(title: "Liked WODs") { _ in
            let liked = LikedWODsVC()
            liked.modalPresentationStyle = .fullScreen
            self.present(liked, animated: true)
        }
        
        let myWODs = UIAction(title: "My WODs") { _ in
            let my = MyWODsVC()
            my.modalPresentationStyle = .fullScreen
            self.present(my, animated: true)
        }
        
        let logOut = UIAction(title: "Log Out") { _ in
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                self.showError(descr: signOutError.localizedDescription)
            }
        }

        if isLogged {
            userBtn.setBackgroundImage(UIImage(systemName: "person"), for: .normal)
            userBtn.menu = UIMenu(title: "", children: [profile, likedWOD, myWODs, logOut])
        } else {
            userBtn.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
            userBtn.menu = UIMenu(title: "", children: [logIn, signUp])
        }

    }
    
    func showError(descr: String) {
        let alert = UIAlertController(title: "Error", message: descr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }


    
    private func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.stack.topAnchor.constraint(equalTo: userBtn.bottomAnchor),
            
            userBtn.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -10),
            userBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            userBtn.widthAnchor.constraint(equalToConstant: 30),
            userBtn.heightAnchor.constraint(equalToConstant: 30),
            
            btnsStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5),
            btnsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            btnsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            btnsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        if view.frame.height < 700 {
            header.heightAnchor.constraint(equalToConstant: 180).isActive = true
        } else {
            header.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }

        
    }
    
    @objc private func sectionTapped(_ sender: SectionButton) {
        let buttonName = sender.sectionName.text!
        let workoutsVC = WorkoutsVC()
        let exercisesVC = ExercisesVC()
        let addworkoutVC = AddWorkoutVC()
        let popularWODs = PopularWODsVC()
        workoutsVC.modalPresentationStyle = .fullScreen
        exercisesVC.modalPresentationStyle = .fullScreen
        addworkoutVC.modalPresentationStyle = .fullScreen
        popularWODs.modalPresentationStyle = .fullScreen
        
        switch buttonName {
        case "Workouts":
            present(workoutsVC, animated: true)
        case "Exercises":
            present(exercisesVC, animated: true)
        case "Add Workout":
            present(addworkoutVC, animated: true)
        case "Popular Workouts":
            present(popularWODs, animated: true)
        default:
            print(buttonName)
        }
    }

    @objc func goToHeadWOD() {
        let wodview = WODView()
        wodview.wodDict = wodForHead
        wodview.docID = Server.instance.wodsID[0]
        wodview.modalPresentationStyle = .fullScreen
        present(wodview, animated: true)
    }

}


