//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Илья on 15.03.2022.
//

import UIKit

class ViewController: UIViewController {

    private var data: [String] = []
    private let identifierTable = String(describing: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLauout()
    }
    
    var tableView: UITableView = {
         let tableView = UITableView()
         tableView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
    
    lazy var addingHabitButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(changingTimeHabits))
        return item
    }()
    
    private func setupView() {
        title = "ExampleCoreData"
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
        let alertController = UIAlertController(title: "New task", message: "Please add a new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action  in
            let textField = alertController.textFields?.first
            if let newTask = textField?.text {
                self.data.insert(newTask, at: 0)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField{ _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}





// MARK: - Data Source

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}





// MARK: - Delegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identifierTable) else { fatalError() }
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
