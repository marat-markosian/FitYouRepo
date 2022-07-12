//
//  AddWorkoutVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 04.07.2022.
//

import UIKit
import FirebaseFirestore

class AddWorkoutVC: UIViewController {

    private lazy var cancel = UIButton()
    private lazy var nameTxt = CustomTxtField()
    private lazy var priorityChooser = UISegmentedControl(items: ["Task pr.", "Time pr."])
    private lazy var setsORtimeLbl = CustomLabel()
    private lazy var setsORtimeTxt = CustomTxtField()
    private lazy var exercisesLbl = CustomLabel()
    private lazy var addExercise = UIButton()
    private lazy var exercisesTable = UITableView()
    private lazy var addBtn = UIButton()
    
    private var exercisesNumber = 1
    
    var exercises = ExercisesLibrary.instance.exercisesToAdd
    var repetitions = ExercisesLibrary.instance.repetitionsToAdd
    
    var db = Firestore.firestore()

    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        exercises = ExercisesLibrary.instance.exercisesToAdd
        repetitions = ExercisesLibrary.instance.repetitionsToAdd
        exercisesTable.reloadData()
    }
        
    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(cancel)
        view.addSubview(nameTxt)
        view.addSubview(priorityChooser)
        view.addSubview(addBtn)
        
        cancel.translatesAutoresizingMaskIntoConstraints = false
        nameTxt.translatesAutoresizingMaskIntoConstraints = false
        priorityChooser.translatesAutoresizingMaskIntoConstraints = false
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.red, for: .normal)
        cancel.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
        
        nameTxt.placeholder = "name"
        
        priorityChooser.addTarget(self, action: #selector(priorityChanged), for: .valueChanged)
        
        setSetsANDTimeChooser()
        setExercisesController()
        setExercisesTable()
        
        addBtn.setTitleColor(.black, for: .normal)
        addBtn.setTitle("Add", for: .normal)
        addBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        addBtn.addTarget(self, action: #selector(addWOD), for: .touchUpInside)
    }
    
    private func setSetsANDTimeChooser() {
        view.addSubview(setsORtimeLbl)
        view.addSubview(setsORtimeTxt)
        
        setsORtimeLbl.translatesAutoresizingMaskIntoConstraints = false
        setsORtimeTxt.translatesAutoresizingMaskIntoConstraints = false
        
        setsORtimeLbl.text = "Sets/Total Time:"
        setsORtimeTxt.placeholder = "number"
        
        setsORtimeTxt.keyboardType = .numberPad
    }
    
    private func setExercisesController() {
        view.addSubview(exercisesLbl)
        view.addSubview(addExercise)
        
        exercisesLbl.translatesAutoresizingMaskIntoConstraints = false
        addExercise.translatesAutoresizingMaskIntoConstraints = false
        
        exercisesLbl.text = "Exercises"
        
        addExercise.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        addExercise.tintColor = .black
        addExercise.addTarget(self, action: #selector(addExercisesToTable), for: .touchUpInside)
    }
    
    private func setExercisesTable() {
        view.addSubview(exercisesTable)
        
        exercisesTable.translatesAutoresizingMaskIntoConstraints = false
        
        exercisesTable.separatorStyle = .none
        
        exercisesTable.register(CustomTableCell.self, forCellReuseIdentifier: "Reuse")
        exercisesTable.delegate = self
        exercisesTable.dataSource = self
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            cancel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cancel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            nameTxt.topAnchor.constraint(equalTo: cancel.bottomAnchor, constant: 20),
            nameTxt.leadingAnchor.constraint(equalTo: cancel.leadingAnchor),
            nameTxt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameTxt.heightAnchor.constraint(equalToConstant: 40),

            priorityChooser.topAnchor.constraint(equalTo: nameTxt.bottomAnchor, constant: 15),
            priorityChooser.leadingAnchor.constraint(equalTo: nameTxt.leadingAnchor),
            priorityChooser.trailingAnchor.constraint(equalTo: nameTxt.trailingAnchor),
            priorityChooser.heightAnchor.constraint(equalToConstant: 30),
            
            setsORtimeLbl.topAnchor.constraint(equalTo: priorityChooser.bottomAnchor, constant: 15),
            setsORtimeLbl.leadingAnchor.constraint(equalTo: priorityChooser.leadingAnchor),
            
            setsORtimeTxt.topAnchor.constraint(equalTo: setsORtimeLbl.topAnchor),
            setsORtimeTxt.bottomAnchor.constraint(equalTo: setsORtimeLbl.bottomAnchor),
            setsORtimeTxt.leadingAnchor.constraint(equalTo: setsORtimeLbl.trailingAnchor, constant: 5),
            setsORtimeTxt.widthAnchor.constraint(equalToConstant: 70),
            
            exercisesLbl.topAnchor.constraint(equalTo: setsORtimeLbl.bottomAnchor, constant: 15),
            exercisesLbl.leadingAnchor.constraint(equalTo: setsORtimeLbl.leadingAnchor),
            
            addExercise.leadingAnchor.constraint(equalTo: exercisesLbl.trailingAnchor, constant: 5),
            addExercise.centerYAnchor.constraint(equalTo: exercisesLbl.centerYAnchor),
            
            exercisesTable.topAnchor.constraint(equalTo: exercisesLbl.bottomAnchor, constant: 10),
            exercisesTable.leadingAnchor.constraint(equalTo: exercisesLbl.leadingAnchor),
            exercisesTable.trailingAnchor.constraint(equalTo: nameTxt.trailingAnchor),
            
            addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addBtn.topAnchor.constraint(equalTo: exercisesTable.bottomAnchor, constant: 30)
        ])
        
        if view.frame.height < 700 {
            exercisesTable.heightAnchor.constraint(equalToConstant: 250).isActive = true
        } else {
            exercisesTable.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }

    }
    
    private func checkItems() -> Bool {
        if nameTxt.text == "" || priorityChooser.selectedSegmentIndex == -1 || setsORtimeTxt.text == "" || exercises.count == 0 {
            return false
        }
        return true
    }
    
    func showError(descr: String) {
        let alert = UIAlertController(title: "Error", message: descr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }
    
    @objc private func cancelTap() {
        ExercisesLibrary.instance.repetitionsToAdd = []
        ExercisesLibrary.instance.exercisesToAdd = []
        
        dismiss(animated: true)
    }
    
    @objc private func priorityChanged() {
        if priorityChooser.selectedSegmentIndex == 0 {
            setsORtimeLbl.text = "Total Time:"
        } else if priorityChooser.selectedSegmentIndex == 1 {
            setsORtimeLbl.text = "Sets:"
        } else {
            setsORtimeLbl.text = "Sets/Total Time:"
        }
    }
    
    @objc private func addExercisesToTable() {
        exercisesNumber += 1
        exercisesTable.reloadData()
    }
    
    @objc private func addWOD() {
        if checkItems() {
            
            var priority: String = ""
            if priorityChooser.selectedSegmentIndex == 0 {
                priority = "Task"
            } else if priorityChooser.selectedSegmentIndex == 1 {
                priority = "Time"
            }
            
            var setsORtime: Int = 0
            if setsORtimeTxt.text != "" {
                setsORtime = Int(setsORtimeTxt.text!)!
            }
            let whoLiked: [String] = []
            let whoAddedResultIDs: [String] = []
            let names: [String] = []
            let results: [Int] = []
            
            var ref: DocumentReference? = nil
            ref = db.collection("WODs").addDocument(data: [
                "name": nameTxt.text,
                "priority": priority,
                "setsORtime": setsORtime,
                "exercises": exercises,
                "repetitions": repetitions,
                "creator": Server.instance.userID,
                "whoLiked": whoLiked,
                "whoAddedResultIDs": whoAddedResultIDs,
                "names": names,
                "results": results
            ]) { err in
                if let err = err {
                    self.showError(descr: err.localizedDescription)
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.dismiss(animated: true)
                }
            }
        } else {
            showError(descr: "Need to set all items")
        }
    }
}

extension AddWorkoutVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if exercises.count <= indexPath.row {
            let editor = ExerciseEditorVC()
            editor.modalPresentationStyle = .fullScreen
            present(editor, animated: true)

        } else {

            showError(descr: "Sorry, you can`t edit")

        }
            
    }
    
}

extension AddWorkoutVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercisesNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath) as? CustomTableCell {
            if exercises.isEmpty || repetitions.isEmpty {
                return cell
            } else if exercises.count < exercisesNumber {
                return cell
            }else {
                let exerciseName = exercises[indexPath.row]
                let repetitionsForExercisce = repetitions[indexPath.row]
                cell.setNameAndRep(exerciseName, repetitions: repetitionsForExercisce)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
}
