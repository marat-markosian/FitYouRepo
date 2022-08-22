//
//  ExercisesVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 23.06.2022.
//

import UIKit

class ExercisesVC: CustomVC {

    private lazy var header = WODHeader()
    private lazy var exercisesTable = UITableView()

    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(header)
        view.addSubview(exercisesTable)
        header.addSubview(backBtn)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        exercisesTable.translatesAutoresizingMaskIntoConstraints = false

        header.changeWOD(to: "Exercises")
        header.hideName()
        header.hidePriority()
        
        exercisesTable.delegate = self
        exercisesTable.dataSource = self
        
        exercisesTable.register(CustomTableCell.self, forCellReuseIdentifier: "Reuse")
        exercisesTable.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "ReuseHead")
        exercisesTable.backgroundColor = .white
        exercisesTable.showsVerticalScrollIndicator = false
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.stack.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 3),
            
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backBtn.leadingAnchor.constraint(equalTo: header.stack.leadingAnchor),
            backBtn.widthAnchor.constraint(equalToConstant: 20),
            backBtn.heightAnchor.constraint(equalToConstant: 30),

            exercisesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exercisesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exercisesTable.topAnchor.constraint(equalTo: header.bottomAnchor),
            exercisesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        if view.frame.height < 700 {
            header.heightAnchor.constraint(equalToConstant: 90).isActive = true
        } else {
            header.heightAnchor.constraint(equalToConstant: 130).isActive = true
        }

    }
        
}

extension ExercisesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReuseHead") as? CustomHeader {
            header.title.text = ExercisesLibrary.instance.alphabet[section]
            return header
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ExercisesVC: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let libraryInstance = ExercisesLibrary.instance

        return libraryInstance.alphabet.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let libraryInstance = ExercisesLibrary.instance

        let headLetter = libraryInstance.alphabet[section]
        
        if let rowsNum = libraryInstance.exercisesDict[headLetter]?.count {
            return rowsNum
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let libraryInstance = ExercisesLibrary.instance

        let headLetter = libraryInstance.alphabet[indexPath.section]
        
        guard let sectionExercises = ExercisesLibrary.instance.exercisesDict[headLetter] else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath) as? CustomTableCell {
            cell.setName(sectionExercises[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
