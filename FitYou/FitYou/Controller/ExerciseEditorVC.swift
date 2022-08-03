//
//  ExerciseEditorVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 05.07.2022.
//

import UIKit

class ExerciseEditorVC: UIViewController {
    
    private lazy var exercisePicker = UIPickerView()
    private lazy var repetitionsTxt = CustomTxtField()
    private lazy var okBtn = UIButton()
    private lazy var cancelBtn = UIButton()
    
    var exercises: [String] {
        var array: [String] = []
        for letter in ExercisesLibrary.instance.alphabet {
            array += ExercisesLibrary.instance.exercisesDict[letter] ?? []
        }
        return array
    }
    
    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }

    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(cancelBtn)
        view.addSubview(exercisePicker)
        view.addSubview(repetitionsTxt)
        view.addSubview(okBtn)
        
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        exercisePicker.translatesAutoresizingMaskIntoConstraints = false
        repetitionsTxt.translatesAutoresizingMaskIntoConstraints = false
        okBtn.translatesAutoresizingMaskIntoConstraints = false
        
        exercisePicker.dataSource = self
        exercisePicker.delegate = self
        
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.red, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        repetitionsTxt.placeholder = "repetitions number"
        repetitionsTxt.keyboardType = .numberPad
        
        okBtn.setTitleColor(.black, for: .normal)
        okBtn.setTitle("OK", for: .normal)
        okBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        okBtn.addTarget(self, action: #selector(okBtnTapped), for: .touchUpInside)
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            cancelBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cancelBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

            exercisePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            exercisePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            repetitionsTxt.topAnchor.constraint(equalTo: exercisePicker.bottomAnchor, constant: 30),
            repetitionsTxt.heightAnchor.constraint(equalToConstant: 40),
            repetitionsTxt.widthAnchor.constraint(equalToConstant: 200),
            repetitionsTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            okBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okBtn.topAnchor.constraint(equalTo: repetitionsTxt.bottomAnchor, constant: 20)
        ])
    }
    
    func showError(descr: String) {
        let alert = UIAlertController(title: "Error", message: descr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }
    
    @objc private func okBtnTapped() {
        if repetitionsTxt.text == "" {
            showError(descr: "Try again")
        } else {
            let repetitions = Int(repetitionsTxt.text!)!
            let exerciseName = exercises[exercisePicker.selectedRow(inComponent: 0)]
            ExercisesLibrary.instance.exercisesToAdd.append(exerciseName)
            ExercisesLibrary.instance.repetitionsToAdd.append(repetitions)
            
            dismiss(animated: true)
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }

}

extension ExerciseEditorVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = exercises[row]
        return title
    }

}

extension ExerciseEditorVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        exercises.count
    }
    
    
}
