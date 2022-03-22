//
//  TableViewController.swift
//  CoreDataExample
//
//  Created by Илья on 14.03.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    private var data: [String] = ["1", "2"]
    private let identifierTable = String(describing: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ExampleCoreData"
        view.backgroundColor = .red
    }
    
    var tableView: UITableView = {
         let tableView = UITableView()
         tableView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
    
    lazy var addingHabitButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(changingTimeHabits))
        return item
    }()
    
    private func setupView() {
         self.navigationController?.navigationBar.prefersLargeTitles = false
         self.navigationController?.navigationBar.tintColor = UIColor(named: "purpleColorApp")
         self.navigationItem.rightBarButtonItem = addingHabitButton
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifierTable)
         tableView.dataSource = self
         tableView.delegate = self
         view.addSubview(tableView)
     }

     private func setupLauout() {
         NSLayoutConstraint.activate([
             tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         ])
     }
    
    @objc private func changingTimeHabits() {
         print("Pressed edit bar item, method -> changingTimeHabits")
     }
}




// MARK: - Data Source

extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // Заголовок для header'a
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
}




// MARK: - Delegate

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identifierTable) else { fatalError() }
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
}
