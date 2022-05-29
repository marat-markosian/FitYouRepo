//
//  WODView.swift
//  FitYou
//
//  Created by Марат Маркосян on 27.05.2022.
//

import UIKit
import SwiftUI

class WODView: UIViewController {
    
    private lazy var header = WODHeader()
    private lazy var backBtn = UIButton()
    private lazy var likeBtn = UIButton()
    private var setsAndTime: CustomLabel {
        let label = CustomLabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        if wod?.sets == nil {
            if let time = wod?.time {
                label.text = "Time: \(time)"
            }
        } else {
            if let sets = wod?.sets {
                label.text = "Sets: \(sets)"
            }
        }
        return label
    }
    private lazy var exercisesTable = UITableView()
    private lazy var resultsLbl = CustomLabel()
    private lazy var first = CustomLabel()
    private lazy var second = CustomLabel()
    private lazy var third = CustomLabel()
    private lazy var addResultBtn = UIButton()
    
    var wod: WODModel? = nil
    var exercisesForTable: [String]? = nil
    
    let stack = UIStackView()
    let mainStack = UIStackView()

    
    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpStacks()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(header)
        header.addSubview(backBtn)
        header.addSubview(likeBtn)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        backBtn.setBackgroundImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.tintColor = .black
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)

        likeBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        likeBtn.tintColor = .red
        likeBtn.contentMode = .scaleAspectFit
        
        if let newwod = wod {
            header.setUpName(newwod.name)
            header.setUpPriority(newwod.priority)
            exercisesForTable = newwod.exercises
        }

    }
    
    private func setUpStacks() {
        exercisesTable.dataSource = self
        exercisesTable.delegate = self
        exercisesTable.register(ExerciseCell.self, forCellReuseIdentifier: "Reuse")
        exercisesTable.backgroundColor = .white
        exercisesTable.showsVerticalScrollIndicator = false
        
        resultsLbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        
        resultsLbl.text = "Best results:"
        first.text = "1"
        second.text = "2"
        third.text = "3"
        
        addResultBtn.setTitleColor(.black, for: .normal)
        addResultBtn.titleLabel?.font = UIFont(name: "Avenir", size: 25)
        addResultBtn.setTitle("Add my result", for: .normal)
        
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 3
        
        stack.addArrangedSubview(setsAndTime)
        stack.addArrangedSubview(exercisesTable)
        stack.addArrangedSubview(resultsLbl)
        stack.addArrangedSubview(first)
        stack.addArrangedSubview(second)
        stack.addArrangedSubview(third)
        stack.addArrangedSubview(addResultBtn)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
//            newView.topAnchor.constraint(equalTo: view.topAnchor),
//            newView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            newView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            newView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            contentView.topAnchor.constraint(equalTo: newView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: newView.bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: newView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: newView.trailingAnchor),
//            contentView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
//            contentView.centerYAnchor.constraint(equalTo: newView.centerYAnchor),

            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.stack.leadingAnchor.constraint(equalTo: backBtn.leadingAnchor),
            header.stack.topAnchor.constraint(equalTo: backBtn.bottomAnchor),
            
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backBtn.leadingAnchor.constraint(equalTo: header.stack.leadingAnchor),
            backBtn.widthAnchor.constraint(equalToConstant: 15),
            backBtn.heightAnchor.constraint(equalToConstant: 20),
            
            likeBtn.bottomAnchor.constraint(equalTo: header.stack.bottomAnchor),
            likeBtn.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -10),
            likeBtn.widthAnchor.constraint(equalToConstant: 25),
            likeBtn.heightAnchor.constraint(equalToConstant: 25),
            
            stack.topAnchor.constraint(equalTo: header.bottomAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        
        if let exercisesNumber = wod?.exercises.count {
            if exercisesNumber > 5 {
                let newHeight = exercisesNumber * 35
                exercisesTable.heightAnchor.constraint(equalToConstant: CGFloat(newHeight)).isActive = true
            } else {
                exercisesTable.heightAnchor.constraint(equalToConstant: 200).isActive = true
            }
        } else {
            exercisesTable.heightAnchor.constraint(equalToConstant: 250).isActive = true
        }
        
        if view.frame.height < 600 {
            header.heightAnchor.constraint(equalToConstant: 140).isActive = true
        } else {
            header.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }

    }

    @objc private func backAction() {
        dismiss(animated: true)
    }

}

extension WODView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let table = exercisesForTable {
            return table.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") as? ExerciseCell {
            if let table = exercisesForTable {
                cell.setName(table[indexPath.row])
                return cell
            }
        }
        return ExerciseCell()
    }
    
}

extension WODView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
