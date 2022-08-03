//
//  ResultsVC.swift
//  FitYou
//
//  Created by Марат Маркосян on 01.08.2022.
//

import UIKit

class ResultsVC: UIViewController {
    
    private lazy var resultsTable = UITableView()
    
    var names = [String]()
    var results = [Float]()
    var priority = ""

    override func loadView() {
        super.loadView()
        
        setUpSubviews()
        setUpAutoLayout()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(resultsTable)
        
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        
        resultsTable.register(CustomTableCell.self, forCellReuseIdentifier: "Reuse")
        resultsTable.delegate = self
        resultsTable.dataSource = self
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            resultsTable.topAnchor.constraint(equalTo: view.topAnchor),
            resultsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            resultsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}

extension ResultsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

extension ResultsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") as? CustomTableCell {
            if priority == "Time" {
                cell.setName("\(names[indexPath.row]) - \(results[indexPath.row]) sets")
                return cell
            } else {
                cell.setName("\(names[indexPath.row]) - \(results[indexPath.row]) minutes")
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
