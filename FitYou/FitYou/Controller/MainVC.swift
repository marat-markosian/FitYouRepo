//
//  ViewController.swift
//  FitYou
//
//  Created by Марат Маркосян on 26.05.2022.
//

import UIKit

class MainVC: UIViewController {
    
    private lazy var header = WODHeader()
    private lazy var userBtn = UIButton()
    private lazy var workoutsBtn = SectionButton()
    private lazy var addWorkoutBtn = SectionButton()
    private lazy var popularWorkoutsBtn = SectionButton()
    private lazy var exercisesBtn = SectionButton()
    
    let btnsStack = UIStackView()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        setUpSubviews()
        setUpAutoLayout()
    }

    private func setUpSubviews() {
        view.addSubview(header)
        header.addSubview(userBtn)
        view.addSubview(btnsStack)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        userBtn.translatesAutoresizingMaskIntoConstraints = false
        
        userBtn.setBackgroundImage(UIImage(systemName: "person.crop.circle.fill"), for: .normal)
        userBtn.tintColor = .black
        
        header.changeWOD(to: "Workout of the Day")

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
        
        if view.frame.height < 600 {
            header.heightAnchor.constraint(equalToConstant: 180).isActive = true
        } else {
            header.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }

        
    }
    
    @objc private func sectionTapped(_ sender: SectionButton) {
        let buttonName = sender.sectionName.text!
        let workoutsVC = WorkoutsVC()
        workoutsVC.modalPresentationStyle = .fullScreen
        
        switch buttonName {
        case "Workouts":
            present(workoutsVC, animated: true)
        default:
            print(buttonName)
        }
    }


}

