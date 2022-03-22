//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Илья on 15.03.2022.
//

import UIKit
import CoreData

class TODOViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLauout()
        //removeElement()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = getContext()
        
        // Запрос, с помощью которого получаем все entity объекты хранящиеся в task.
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Меняем порядок вывода задач
        let sordDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sordDescriptor]
        
        // Получение объектов
        do {
            data = try context.fetch(fetchRequest)
        } catch let error as NSError {
            error.localizedDescription
        }
    }
    
    

    // MARK: Private objects
    
    private var data: [Task] = []
    private let identifierTable = String(describing: TODOViewController.self)
    
    private var tableView: UITableView = {
         let tableView = UITableView()
         tableView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
    
    private lazy var addingHabitButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(saveTaskButton))
        return item
    }()
    
    
    
    // MARK: Private methods
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @objc private func saveTaskButton() {
        let alertController = UIAlertController(title: "New task", message: "Please add a new task", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let textField = alertController.textFields?.first
            if let newTaskTitle = textField?.text {
                self.saveTask(withTitle: newTaskTitle)
                self.tableView.reloadData()
            }
        }
        
        alertController.addTextField{ _ in }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Добавление новой привычки, в массив Task
    private func saveTask(withTitle title: String) {
        
        // Получение контекста
        let context = getContext()
        
        // Добираемся до созданной сущности Task
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        // Создание объекта задачи
        let taskObject = Task(entity: entity, insertInto: context)
        
        // Добовление к объекту заголовка
        taskObject.title = title
        
        // Сохранения контекста
        do {
            try context.save()
            data.append(taskObject)
        } catch let error as NSError {
            error.localizedDescription
        }
    }
    
    // Удаление всех объектов
    private func removeElement() {
        let context = getContext()
        
        // Запрос, с помощью которого получаем все entity объекты хранящиеся в task.
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Пытаемся получить все данные из контекста
        if let results = try? context.fetch(fetchRequest) {
            for object in results {
                context.delete(object)
            }
        }
        
        // Сохранения контекста
        do {
            try context.save()
        } catch let error as NSError {
            error.localizedDescription
        }
    }
    
    
    
    
    // MARK: Setup View
    
    private func setupView() {
        title = "TD.CoreData"
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
}





// MARK: - Table Data Source

extension TODOViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}





// MARK: - Table Delegate

extension TODOViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identifierTable) else { fatalError() }
        let task = data[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}
