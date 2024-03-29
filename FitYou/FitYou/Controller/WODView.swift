//
//  WODView.swift
//  FitYou
//
//  Created by Марат Маркосян on 27.05.2022.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class WODView: CustomVC {
    
    private lazy var header = WODHeader()
    private lazy var likeBtn = UIButton()
    private var setsAndTime: CustomLabel {
        let label = CustomLabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        if wodDict["priority"] as! String == "Time" {
            if let time = wodDict["setsORtime"] as? Float {
                label.text = "Time: \(time / 10 * 10) min."
            }
        } else {
            if let sets = wodDict["setsORtime"] {
                label.text = "Sets: \(sets)"
            }
        }
        return label
    }
    private lazy var exercisesTable = UITableView()
    private lazy var descriptionText = UITextView()
    private lazy var resultsBtn = UIButton()
    private lazy var addResultBtn = UIButton()
    private lazy var resultTxt = CustomTxtField()
    var isfirstTap = true
    
    var wodDict: [String: Any] = [:]
    var exercisesForTable: [String]? = nil
    var repetitionsForTable: [Int]? = nil
    var docID: String = ""
    var usersIDWhoAddedResult: [String] = []
    var usersNames: [String] = []
    var results: [Float] = []
    
    let stack = UIStackView()
    
    let db = Firestore.firestore()

    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        isfirstTap = true
        
        cancelBtn.isHidden = true
        
        setUpSubviews()
        setUpStacks()
        setUpAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            likeBtn.isHidden = true
            addResultBtn.setTitle("Log In to add result", for: .normal)
            addResultBtn.isUserInteractionEnabled = false
        } else {
            addResultBtn.setTitle("Add my result", for: .normal)
        }
        
        for index in 0 ..< usersIDWhoAddedResult.count {
            if usersIDWhoAddedResult[index] == Server.instance.userID {
                addResultBtn.isUserInteractionEnabled = false
                let result = results[index]
                addResultBtn.setTitle("Your result - \(result)", for: .normal)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(header)
        header.addSubview(likeBtn)
        header.addSubview(backBtn)
        view.addSubview(descriptionText)
        view.addSubview(resultsBtn)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        resultsBtn.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        
        isLiked()
        likeBtn.tintColor = .red
        likeBtn.contentMode = .scaleAspectFit
        likeBtn.addTarget(self, action: #selector(liked), for: .touchUpInside)
        
        header.setUpName(wodDict["name"] as! String)
        header.setUpPriority(wodDict["priority"] as! String)
        exercisesForTable = wodDict["exercises"] as? [String]
        repetitionsForTable = wodDict["repetitions"] as? [Int]
        descriptionText.text = wodDict["description"] as? String
        
        descriptionText.showsVerticalScrollIndicator = false
        descriptionText.isEditable = false
        descriptionText.font = UIFont(name: "Avenir", size: 14)
        
        usersIDWhoAddedResult = wodDict["whoAddedResultIDs"] as! [String]
        usersNames = wodDict["names"] as? [String] ?? []
        results = wodDict["results"] as? [Float] ?? []
        
        resultsBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        resultsBtn.setTitle("Results", for: .normal)
        resultsBtn.setTitleColor(.black, for: .normal)
        resultsBtn.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        resultsBtn.layer.borderColor = CGColor.init(red: 104/255, green: 240/255, blue: 135/255, alpha: 0.5)
        resultsBtn.layer.borderWidth = 2
        resultsBtn.layer.cornerRadius = 10

        setResultElements()
    }
    
    private func setUpStacks() {
        exercisesTable.dataSource = self
        exercisesTable.delegate = self
        exercisesTable.register(CustomTableCell.self, forCellReuseIdentifier: "Reuse")
        exercisesTable.backgroundColor = .white
        exercisesTable.showsVerticalScrollIndicator = false
                        
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 3
        
        stack.addArrangedSubview(setsAndTime)
        stack.addArrangedSubview(exercisesTable)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
    }
    
    private func setResultElements() {
        view.addSubview(addResultBtn)
        view.addSubview(resultTxt)

        addResultBtn.setTitleColor(.black, for: .normal)
        addResultBtn.titleLabel?.font = UIFont(name: "Avenir", size: 25)
        addResultBtn.addTarget(self, action: #selector(addResultTapped), for: .touchUpInside)
        addResultBtn.translatesAutoresizingMaskIntoConstraints = false
        addResultBtn.layer.borderColor = CGColor.init(red: 104/255, green: 240/255, blue: 135/255, alpha: 0.5)
        addResultBtn.layer.borderWidth = 2
        addResultBtn.layer.cornerRadius = 10
        
        if wodDict["priority"] as! String == "Time" {
            resultTxt.placeholder = "number of sets"
            resultTxt.keyboardType = .numberPad
        } else {
            resultTxt.placeholder = "time(min.sec)"
            resultTxt.keyboardType = .decimalPad
        }
        resultTxt.translatesAutoresizingMaskIntoConstraints = false
        resultTxt.isHidden = true
        resultTxt.delegate = self
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.stack.leadingAnchor.constraint(equalTo: backBtn.leadingAnchor),
            header.stack.topAnchor.constraint(equalTo: backBtn.bottomAnchor),
            
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backBtn.leadingAnchor.constraint(equalTo: header.stack.leadingAnchor),
            backBtn.widthAnchor.constraint(equalToConstant: 20),
            backBtn.heightAnchor.constraint(equalToConstant: 30),
            
            likeBtn.bottomAnchor.constraint(equalTo: header.stack.bottomAnchor),
            likeBtn.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -10),
            likeBtn.widthAnchor.constraint(equalToConstant: 25),
            likeBtn.heightAnchor.constraint(equalToConstant: 25),
            
            stack.topAnchor.constraint(equalTo: header.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            descriptionText.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 10),
            descriptionText.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            descriptionText.heightAnchor.constraint(equalToConstant: 100),
                        
        ])
        
        if let exercisesNumber = exercisesForTable?.count {
            if exercisesNumber < 5 {
                let newHeight = exercisesNumber * 50
                exercisesTable.heightAnchor.constraint(equalToConstant: CGFloat(newHeight)).isActive = true
                if exercisesNumber == 1{
                    stack.heightAnchor.constraint(equalToConstant: 100).isActive = true
                }
                if exercisesNumber == 2 {
                    stack.heightAnchor.constraint(equalToConstant: 150).isActive = true
                }
                if exercisesNumber == 3 {
                    stack.heightAnchor.constraint(equalToConstant: 200).isActive = true
                } else if exercisesNumber == 4 {
                    stack.heightAnchor.constraint(equalToConstant: 250).isActive = true
                }
            } else {
                exercisesTable.heightAnchor.constraint(equalToConstant: 250).isActive = true
                stack.heightAnchor.constraint(equalToConstant: 300).isActive = true
            }
        }
        
        if view.frame.height < 700 {
            NSLayoutConstraint.activate([
                header.heightAnchor.constraint(equalToConstant: 140),
                
                addResultBtn.topAnchor.constraint(equalTo: resultsBtn.bottomAnchor, constant: 10),
                addResultBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                addResultBtn.widthAnchor.constraint(equalToConstant: 200),
                
                resultTxt.bottomAnchor.constraint(equalTo: addResultBtn.bottomAnchor),
                resultTxt.leadingAnchor.constraint(equalTo: addResultBtn.trailingAnchor, constant: 5),
                resultTxt.heightAnchor.constraint(equalToConstant: 40),
                resultTxt.widthAnchor.constraint(equalToConstant: 150),
                
                resultsBtn.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 15),
                resultsBtn.leadingAnchor.constraint(equalTo: addResultBtn.leadingAnchor),
                resultsBtn.widthAnchor.constraint(equalToConstant: 100)

            ])
        } else {
            NSLayoutConstraint.activate([
                header.heightAnchor.constraint(equalToConstant: 200),
                
                addResultBtn.topAnchor.constraint(equalTo: resultsBtn.bottomAnchor, constant: 10),
                addResultBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                addResultBtn.widthAnchor.constraint(equalToConstant: 200),
                
                resultTxt.topAnchor.constraint(equalTo: addResultBtn.bottomAnchor, constant: 5),
                resultTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                resultTxt.heightAnchor.constraint(equalToConstant: 40),
                resultTxt.widthAnchor.constraint(equalToConstant: 200),
                
                resultsBtn.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 15),
                resultsBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                resultsBtn.widthAnchor.constraint(equalToConstant: 100)
            ])

        }

    }
    
    func isLiked() {
        if let likes = wodDict["whoLiked"] as? [String] {
            if likes.count == 0 {
                likeBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            }
            for userID in likes {
                if userID == Server.instance.userID {
                    likeBtn.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    likeBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
        }
    }
        
    @objc private func showResults() {
        let resultsVC = ResultsVC()
        resultsVC.results = results
        resultsVC.names = usersNames
        resultsVC.priority = wodDict["priority"] as! String
        
        present(resultsVC, animated: true)
    }
    
    @objc private func liked() {
        
        if likeBtn.currentBackgroundImage == UIImage(systemName: "heart") {
            let document = db.collection("WODs").document(docID)
            document.updateData([
                "whoLiked" : FieldValue.arrayUnion([Server.instance.userID])
            ])
            
            likeBtn.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            let document = db.collection("WODs").document(docID)
            document.updateData([
                "whoLiked" : FieldValue.arrayRemove([Server.instance.userID])
            ])
            
            likeBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
        
    }
    
    @objc private func addResultTapped() {
        if isfirstTap {
            addResultBtn.setTitle("Add", for: .normal)
                        
            resultTxt.isHidden = false
            isfirstTap = false
        } else {
            if resultTxt.text != "" {
                let resultNum = Float(resultTxt.text!)!
                let document = db.collection("WODs").document(docID)
                document.updateData([
                    "whoAddedResultIDs" : FieldValue.arrayUnion([Server.instance.userID]),
                    "names" : FieldValue.arrayUnion([Server.instance.userDisplayName]),
                    "results" : FieldValue.arrayUnion([resultNum])
                ]) { error in
                    if let err = error {
                        self.showError(descr: err.localizedDescription)
                    } else {
                        self.addResultBtn.setTitle("Your result - \(resultNum)", for: .normal)
                        self.addResultBtn.isUserInteractionEnabled = false
                    }
                }
                resultTxt.isHidden = true
            } else {
                showError(descr: "Need result number to save")
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
}

extension WODView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let table = exercisesForTable else { return 0 }
            return table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") as? CustomTableCell {
            if let table = exercisesForTable, let rep = repetitionsForTable {
                cell.setNameAndRep(table[indexPath.row], repetitions: rep[indexPath.row])
                return cell
            }
        }
        return CustomTableCell()
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

extension WODView: UITextFieldDelegate {
    
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
