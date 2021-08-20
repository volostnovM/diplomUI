//
//  HabitViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

enum ShowVC {
    case createHabit
    case editHabit
}

class HabitViewController: UIViewController {
    
    public var currentLastVC = ShowVC.createHabit
    
    lazy var newHabit = Habit(name: "Выпить стакан воды перед завтраком",
                                 date: Date(),
                                 color: .systemRed)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.title = "Создать"
        
        setupView()
    }
    
    lazy var nameHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ"
        label.font = .FootNoteBold
        label.numberOfLines = 1
        return label
    }()
    
    lazy var nameHabitTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = .FootNote
        
        return textField
    }()

    lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.font = .FootNoteBold
        return label
    }()
    
    lazy var colorPickerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCornerWithRadius(15, top: true, bottom: true, shadowEnabled: false)
        button.addTarget(self, action: #selector(tapColorPicker), for: .touchUpInside)
        button.backgroundColor = .yellow
        
        return button
    }()
    
    @objc func tapColorPicker() {
        
        present(colorPickerViewController, animated: true, completion: nil)
    }
    
    private lazy var colorPickerViewController: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        return picker
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ"
        label.font = .FootNoteBold
        return label
    }()
    
    
    lazy var habitTimeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = newHabit.dateString
        label.textColor = .CustomPurple
        return label
    }()
    
    lazy var datepicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        datepicker.datePickerMode = .time
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datepicker
    }()
    
    @objc func dateChanged() {
        print("меняем время")
        newHabit.date = datepicker.date
        habitTimeTextLabel.text = newHabit.dateString
    }
    
    @objc func actionCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func actionSaveButton(_ sender: Any) {
        print("tap Save")
        
        guard let text = nameHabitTextField.text, !text.isEmpty else {
            let alertController = UIAlertController(title: "Внимание", message: "Вы не ввели привычку!", preferredStyle: .alert)
            
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(actionOk)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if let valueName = nameHabitTextField.text {
            newHabit.name = valueName
            let store = HabitsStore.shared
            store.habits.append(newHabit)
            dismiss(animated: true, completion: nil)
            print("\(newHabit.name) \(newHabit.date) \(newHabit.color)")
        }
    }
    
    private lazy var deleteHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func deleteButtonPressed() {
        
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(newHabit.name)", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension HabitViewController {
    func setupView() {
        
        let navigBar = UINavigationBar()
        navigBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigBar)

        let const = [
            navigBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigBar.heightAnchor.constraint(equalToConstant: 44),
            navigBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]

        NSLayoutConstraint.activate(const)

        let navigItem = UINavigationItem()

        let leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionCancelButton))
        let rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.done, target: self, action: #selector(actionSaveButton))

        leftBarButtonItem.tintColor = .CustomPurple
        rightBarButtonItem.tintColor = .CustomPurple
        navigItem.rightBarButtonItem = rightBarButtonItem
        navigItem.leftBarButtonItem = leftBarButtonItem
        
        switch currentLastVC {
            case .createHabit: navigItem.title = "Создать"
            case .editHabit: navigItem.title = "Править"
        }

        navigBar.setItems([navigItem], animated: true)
        navigBar.backgroundColor = .systemGray
        
 
        view.addSubview(nameHabitLabel)
        view.addSubview(nameHabitTextField)
        view.addSubview(colorLabel)
        view.addSubview(colorPickerButton)
        view.addSubview(timeLabel)
        view.addSubview(habitTimeTextLabel)
        view.addSubview(datepicker)
        
        let constraints = [
            nameHabitLabel.topAnchor.constraint(equalTo: navigBar.bottomAnchor, constant: 21),
            nameHabitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nameHabitTextField.topAnchor.constraint(equalTo: nameHabitLabel.bottomAnchor, constant: 7),
            nameHabitTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameHabitTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -65),


            colorLabel.topAnchor.constraint(equalTo: nameHabitTextField.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),


            colorPickerButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorPickerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorPickerButton.heightAnchor.constraint(equalToConstant: 30),
            colorPickerButton.widthAnchor.constraint(equalToConstant: 30),

            timeLabel.topAnchor.constraint(equalTo: colorPickerButton.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            habitTimeTextLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            habitTimeTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            datepicker.topAnchor.constraint(equalTo: habitTimeTextLabel.bottomAnchor, constant: 15),
            datepicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datepicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        
        switch currentLastVC {
        case .createHabit: do { }
        case .editHabit: do {
            view.addSubview(deleteHabitButton)
            
            let constrForButton = [

                deleteHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                deleteHabitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ]
            NSLayoutConstraint.activate(constrForButton)
            }
        }
    }
}


extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            let color = viewController.selectedColor
            newHabit.color = color
            colorPickerButton.backgroundColor = color
        }
}
