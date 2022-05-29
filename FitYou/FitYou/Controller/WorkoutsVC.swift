//
//  WorkoutsVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 27.05.2022.
//

import UIKit

class WorkoutsVC: UIViewController {
    
    private lazy var header = WODHeader()
    private lazy var backBtn = UIButton()
    private lazy var picker = UISegmentedControl(items: ["All", "Time pr.", "Task pr."])
    private lazy var workoutsCollection = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    
    var wods = Server.instance.wods

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        setUpSubviews()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        view.addSubview(header)
        header.addSubview(backBtn)
        view.addSubview(picker)
        
        workoutsCollection.dataSource = self
        workoutsCollection.delegate = self

        view.addSubview(workoutsCollection)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        workoutsCollection.translatesAutoresizingMaskIntoConstraints = false
        
        header.hideName()
        header.hidePriority()
        header.changeWOD(to: "Workouts")
        
        backBtn.setBackgroundImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.tintColor = .black
        backBtn.contentMode = .scaleAspectFit
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        workoutsCollection.register(WorkoutCell.self, forCellWithReuseIdentifier: "Reuse")
        workoutsCollection.backgroundColor = .white
        workoutsCollection.showsVerticalScrollIndicator = false
        
        picker.addTarget(self, action: #selector(prioritySets), for: .valueChanged)
        picker.selectedSegmentIndex = 0
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.stack.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 3),
            
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backBtn.leadingAnchor.constraint(equalTo: header.stack.leadingAnchor),
            backBtn.widthAnchor.constraint(equalToConstant: 15),
            backBtn.heightAnchor.constraint(equalToConstant: 20),
            
            picker.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5),
            picker.heightAnchor.constraint(equalToConstant: 30),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            workoutsCollection.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 10),
            workoutsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            workoutsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            workoutsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        if view.frame.height < 700 {
            header.heightAnchor.constraint(equalToConstant: 90).isActive = true
        } else {
            header.heightAnchor.constraint(equalToConstant: 130).isActive = true
        }

    }

    @objc private func backAction() {
        dismiss(animated: true)
    }
    
    @objc private func prioritySets(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex + 1
        var newWods = [WODModel]()
        switch selectedIndex {
        case 1:
            wods = Server.instance.wods
            workoutsCollection.reloadData()
        case 2:
            wods = Server.instance.wods
            for wod in wods {
                if wod.priority == "Time" {
                    newWods.append(wod)
                }
            }
            wods = newWods
            workoutsCollection.reloadData()
        case 3:
            wods = Server.instance.wods
            for wod in wods {
                if wod.priority == "Task" {
                    newWods.append(wod)
                }
            }
            wods = newWods
            workoutsCollection.reloadData()
        default:
            wods = Server.instance.wods
            workoutsCollection.reloadData()
        }
    }
    
}

extension WorkoutsVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        wods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = workoutsCollection.dequeueReusableCell(withReuseIdentifier: "Reuse", for: indexPath) as? WorkoutCell {
            let wod = wods[indexPath.row]
            cell.setName(wod.name)
            cell.setPriority(wod.priority)
            return cell
        }
        return WorkoutCell()
    }
    
    
}

extension WorkoutsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wodView = WODView()
        wodView.modalPresentationStyle = .fullScreen
        wodView.wod = wods[indexPath.row]
        
        present(wodView, animated: true)
    }
    
}

extension WorkoutsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: workoutsCollection.frame.width, height: 60)
        
    }
    
}
