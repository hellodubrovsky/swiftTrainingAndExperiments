//
//  CarsViewController.swift
//  CoreDataExample
//
//  Created by Илья on 21.03.2022.
//

import UIKit
import CoreData

class CarsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CARS.CoreData"
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        setupView()
        setupLayout()
        getDataFromFile()
        
        let featchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        let mark = segmentControlCar.titleForSegment(at: 0)
        featchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        
        
        do {
            let results = try context.fetch(featchRequest)
            let car = results.first
            insertDataFrom(selectedCar: car!)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
  
    // MARK: PRIVATE OBJECTS
    
    // Get context
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // DateFormatter
    private lazy var dateFormatter: DateFormatter = {
        let dataFormatter = DateFormatter()
        dataFormatter.dateStyle = .short
        dataFormatter.timeStyle = .none
        return dataFormatter
    }()
    
    private let markCar: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.text = "Mark"
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let modelCar: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.text = "Model"
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let imageCar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let lastTimeStartedCar: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let numberOfTripsCar: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let ratingCar: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let choiseCar: UIImageView = {
        let image = UIImageView(image: UIImage(named: "myChoice"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let segmentControlCar: UISegmentedControl = {
        let dataSegmentControl = ["Lamborgini", "Ferrari", "BMW", "Mersedes", "Nissan"]
        let segmentControl = UISegmentedControl(items: dataSegmentControl)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .lightGray
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private let startEngineCar: UIButton = {
        let button = UIButton(type: .custom) as UIButton
        button.backgroundColor = .blue
        button.setTitle("Start", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pressedStartEngineCar), for: .touchUpInside)
        return button
    }()
    
    private let ratePressedCar: UIButton = {
        let button = UIButton(type: .custom) as UIButton
        button.backgroundColor = .blue
        button.setTitle("Rate", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pressedRateCar), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: PRIVATE METHODS
    
    // Вставка наших данных в интерфейс
    private func insertDataFrom(selectedCar car: Car) {
        markCar.text = car.mark
        modelCar.text = car.model
        imageCar.image = UIImage(data: car.imageData!)
        lastTimeStartedCar.text = "Last time started: \(dateFormatter.string(from: car.lastStarted!))"
        numberOfTripsCar.text = "Number of trips: \(car.timesDriven)"
        ratingCar.text = "Rating: \(car.rating) / 10.0"
        choiseCar.isHidden = !(car.myChoise)
        segmentControlCar.tintColor = car.tintColor as? UIColor
    }
    
    // Проверка, были ли наши данные уже загружены
    private func checkDataLoading() -> Bool {
        
        let featchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        featchRequest.predicate = NSPredicate(format: "mark != nil")
        
        var records = 0
        
        do {
            records = try context.count(for: featchRequest)
            print("Is Data there already.")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return false }
        return true
    }
    
    // Получение данных из файла
    private func getDataFromFile() {
        
        guard checkDataLoading() else { return }
        
        // Прописываем путь к Data.plist, откуда извлекаем массив(dataArray) элементов.
        guard let pathToFile = Bundle.main.path(forResource: "Data", ofType: "plist"), let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
        
        // Пробегаем по массиву с нашими данными в Data.plist.
        for dictionary in dataArray {
            
            // Находим нашу сущность - Car, которую добавили в CoreDataExample
            let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
            
            // Создаем наш объект car, по контектсу выше.
            let car = NSManagedObject(entity: entity!, insertInto: context) as! Car
            
            // Создаем словарь, в котором будут перемещены наши данные, с конкретными типами значений.
            let carDictionary = dictionary as! [String: AnyObject]
            
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as! Int16
            car.myChoise = carDictionary["myChoice"] as! Bool
            
            let imageName = carDictionary["imageName"] as? String
            let image = UIImage(named: imageName!)
            let imageData = image!.pngData()
            car.imageData = imageData
            
            if let colorDictionary = carDictionary["tintColor"] as? [String: Float] {
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
        }
    }
    
    private func getColor(colorDictionary: [String: Float]) -> UIColor {
        
        guard let red = colorDictionary["red"], let green = colorDictionary["green"], let blue = colorDictionary["blue"] else { return UIColor() }
        return UIColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
        
    }
    
    @objc private func pressedStartEngineCar() {
        print("Pressed button rate.")
    }
    
    @objc private func pressedRateCar() {
        print("Pressed button start engine.")
    }
    
    private func setupView() {
        view.addSubview(markCar)
        view.addSubview(modelCar)
        view.addSubview(imageCar)
        view.addSubview(lastTimeStartedCar)
        view.addSubview(numberOfTripsCar)
        view.addSubview(ratingCar)
        view.addSubview(choiseCar)
        view.addSubview(segmentControlCar)
        view.addSubview(startEngineCar)
        view.addSubview(ratePressedCar)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            markCar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            markCar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            modelCar.topAnchor.constraint(equalTo: markCar.bottomAnchor, constant: 10),
            modelCar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageCar.topAnchor.constraint(equalTo: modelCar.bottomAnchor, constant: 20),
            imageCar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lastTimeStartedCar.topAnchor.constraint(equalTo: imageCar.bottomAnchor, constant: 20),
            lastTimeStartedCar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            numberOfTripsCar.topAnchor.constraint(equalTo: lastTimeStartedCar.bottomAnchor, constant: 10),
            numberOfTripsCar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            ratingCar.topAnchor.constraint(equalTo: numberOfTripsCar.bottomAnchor, constant: 10),
            ratingCar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            segmentControlCar.topAnchor.constraint(equalTo: ratingCar.bottomAnchor, constant: 20),
            segmentControlCar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentControlCar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            choiseCar.topAnchor.constraint(equalTo: segmentControlCar.bottomAnchor, constant: 30),
            choiseCar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startEngineCar.topAnchor.constraint(equalTo: choiseCar.bottomAnchor, constant: 50),
            startEngineCar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startEngineCar.widthAnchor.constraint(equalToConstant: 100),
            
            ratePressedCar.topAnchor.constraint(equalTo: choiseCar.bottomAnchor, constant: 50),
            ratePressedCar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ratePressedCar.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
}
