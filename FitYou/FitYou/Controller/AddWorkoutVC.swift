//
//  AddWorkoutVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 04.07.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddWorkoutVC: CustomVC {

    private lazy var nameTxt = CustomTxtField()
    private lazy var priorityChooser = UISegmentedControl(items: ["Task pr.", "Time pr."])
    private lazy var setsORtimeLbl = CustomLabel()
    private lazy var setsORtimeTxt = CustomTxtField()
    private lazy var exercisesLbl = CustomLabel()
    private lazy var addExercise = UIButton()
    private lazy var exercisesTable = UITableView()
    private lazy var descriptionTxt = CustomTxtField()
    private lazy var addBtn = UIButton()
    
    private var exercisesNumber = 1
            
    var exercises = ExercisesLibrary.instance.exercisesToAdd
    var repetitions = ExercisesLibrary.instance.repetitionsToAdd
    
    var db = Firestore.firestore()

    override func loadView() {
        super.loadView()
        
        ExercisesLibrary.instance.exercisesToAdd = []
        ExercisesLibrary.instance.repetitionsToAdd = []
                
        setUpSubviews()
        setUpAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            addBtn.setTitle("Log In to add", for: .normal)
            addBtn.isUserInteractionEnabled = false
        } else {
            addBtn.setTitle("Add", for: .normal)
        }

        exercises = ExercisesLibrary.instance.exercisesToAdd
        repetitions = ExercisesLibrary.instance.repetitionsToAdd
        exercisesTable.reloadData()
    }
        
    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(nameTxt)
        view.addSubview(priorityChooser)
        view.addSubview(descriptionTxt)
        view.addSubview(addBtn)
        
        nameTxt.translatesAutoresizingMaskIntoConstraints = false
        priorityChooser.translatesAutoresizingMaskIntoConstraints = false
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        descriptionTxt.translatesAutoresizingMaskIntoConstraints = false
        
        nameTxt.placeholder = "name"
        
        descriptionTxt.placeholder = "description"
        
        priorityChooser.addTarget(self, action: #selector(priorityChanged), for: .valueChanged)
        
        setSetsANDTimeChooser()
        setExercisesController()
        setExercisesTable()
        
        addBtn.setTitleColor(.black, for: .normal)
        addBtn.setTitle("Add", for: .normal)
        addBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        addBtn.addTarget(self, action: #selector(addWOD), for: .touchUpInside)
        addBtn.layer.borderColor = CGColor.init(red: 104/255, green: 240/255, blue: 135/255, alpha: 0.5)
        addBtn.layer.borderWidth = 2
        addBtn.layer.cornerRadius = 10

    }
    
    private func setSetsANDTimeChooser() {
        view.addSubview(setsORtimeLbl)
        view.addSubview(setsORtimeTxt)
        
        setsORtimeLbl.translatesAutoresizingMaskIntoConstraints = false
        setsORtimeTxt.translatesAutoresizingMaskIntoConstraints = false
        
        setsORtimeLbl.text = "Sets/Total Time:"
        setsORtimeTxt.placeholder = "number"
        setsORtimeTxt.delegate = self
        setsORtimeTxt.keyboardType = .decimalPad
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

            nameTxt.topAnchor.constraint(equalTo: cancelBtn.bottomAnchor, constant: 20),
            nameTxt.leadingAnchor.constraint(equalTo: cancelBtn.leadingAnchor),
            nameTxt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameTxt.heightAnchor.constraint(equalToConstant: 40),

            priorityChooser.topAnchor.constraint(equalTo: descriptionTxt.bottomAnchor, constant: 15),
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
            
            descriptionTxt.topAnchor.constraint(equalTo: nameTxt.bottomAnchor, constant: 10),
            descriptionTxt.leadingAnchor.constraint(equalTo: nameTxt.leadingAnchor),
            descriptionTxt.trailingAnchor.constraint(equalTo: nameTxt.trailingAnchor),
            descriptionTxt.heightAnchor.constraint(equalToConstant: 40),
            
            addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addBtn.topAnchor.constraint(equalTo: exercisesTable.bottomAnchor, constant: 15),
            addBtn.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        if view.frame.height < 700 {
            exercisesTable.heightAnchor.constraint(equalToConstant: 250).isActive = true
        } else {
            exercisesTable.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }

    }
    
    private func checkItems() -> Bool {
        if nameTxt.text == "" || priorityChooser.selectedSegmentIndex == -1 || setsORtimeTxt.text == "" || exercises.count == 0 || descriptionTxt.text == "" {
            return false
        }
        return true
    }
    
    @objc private func priorityChanged() {
        if priorityChooser.selectedSegmentIndex == 0 {
            setsORtimeLbl.text = "Sets:"
            setsORtimeTxt.placeholder = "number"
            setsORtimeTxt.keyboardType = .numberPad
        } else if priorityChooser.selectedSegmentIndex == 1 {
            setsORtimeLbl.text = "Total Time:"
            setsORtimeTxt.placeholder = "min.sec"
            setsORtimeTxt.keyboardType = .decimalPad
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
            createWOD()
        } else {
            showError(descr: "Need to set all items")
        }
    }
    
}

extension AddWorkoutVC: WODCreator {
    
    func createWOD() {
        var priority: String = ""
        if priorityChooser.selectedSegmentIndex == 0 {
            priority = "Task"
        } else if priorityChooser.selectedSegmentIndex == 1 {
            priority = "Time"
        }
        
        var setsORtime: Float = 0
        if setsORtimeTxt.text != "" {
            setsORtime = Float(setsORtimeTxt.text!)!
        }
        let whoLiked: [String] = []
        let whoAddedResultIDs: [String] = []
        let names: [String] = []
        let results: [Float] = []
        
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
            "results": results,
            "description": descriptionTxt.text
        ]) { err in
            if let err = err {
                self.showError(descr: err.localizedDescription)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.dismiss(animated: true)
            }
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

extension AddWorkoutVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.count == 5 && string == "" {
           return true
        } else if textField.text?.count == 5 {
            return false
        }

        if textField.text?.count == 0 {
            if string == "," || string == "." {
                return false
            }
        } else {
            if textField.text?.count == 1 {
                if string == "," || string == "." {
                    textField.text = textField.text! + "."
                    return false
                }
            }
            if textField.text?.count == 2 {
                if textField.text!.contains(".") {
                    if string == "." || string == "," {
                        return false
                    }
                }
                if string == "," || string == "." {
                    textField.text = textField.text! + "."
                    return false
                } else if string == "" {
                    return true
                } else if textField.text?.last == "." {
                    return true
                } else {
                    return false
                }
            } else if textField.text!.contains(".") {
                if string == "." || string == "," {
                    return false
                } else if Float(textField.text!)!.truncatingRemainder(dividingBy: 1) > 0.59 && string == "" {
                    return true
                } else if Float(textField.text!)!.truncatingRemainder(dividingBy: 1) > 0.59 {
                    return false
                }
            }
        }
        return true
    }

}
