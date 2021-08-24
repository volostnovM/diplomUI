//
//  HabitViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

class HabitViewController: UIViewController {
    
    weak var reloadingDataDelegate: ReloadingCollectionDataDelegate?
    weak var reloadingTitleDelegate: ReloadingTitleDelegate?
    
    var isOnEditMode: Bool = false
    var editingHabit: Habit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapColorPicker))
        colorPickerButton.isUserInteractionEnabled = true
        colorPickerButton.addGestureRecognizer(tapGestureRecognizer)
        
        setupView()
        dateChanged()
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
    
    lazy var colorPickerButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.roundCornerWithRadius(15, top: true, bottom: true, shadowEnabled: false)
        imageView.backgroundColor = .yellow
        
        return imageView
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
        label.textColor = .black
        label.text = "Каждый день в "
        return label
    }()
    
    lazy var datepickerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        datepickerLabel.text = formatter.string(from: datepicker.date)
    }
    
    @objc func actionCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func actionSaveButton(_ sender: Any) {
        
        if isOnEditMode {
            if let habit = editingHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
                HabitsStore.shared.habits[index].name = nameHabitTextField.text ?? ""
                HabitsStore.shared.habits[index].date = datepicker.date
                HabitsStore.shared.habits[index].color = colorPickerButton.backgroundColor ?? .CustomPurple
                HabitsStore.shared.save()
                reloadingDataDelegate?.updCollection()
                reloadingTitleDelegate?.reloadTitle()
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            guard let text = nameHabitTextField.text, !text.isEmpty else {
                let alertController = UIAlertController(title: "Внимание", message: "Вы не ввели название привычки!", preferredStyle: .alert)
                
                let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(actionOk)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let newHabit = Habit(name: nameHabitTextField.text ?? "",
                                 date: datepicker.date,
                                 color: colorPickerButton.backgroundColor ?? .CustomPurple)
            let store = HabitsStore.shared
            store.habits.append(newHabit)
            reloadingDataDelegate?.updCollection()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setupEditingMode() {
        if isOnEditMode {
            if let habit = editingHabit {
                nameHabitLabel.text = habit.name
                nameHabitLabel.textColor = habit.color
                colorPickerButton.backgroundColor = habit.color
                datepickerLabel.textColor = habit.color
            }
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
        
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(nameHabitLabel.text ?? "")", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            if let habit = self.editingHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
                HabitsStore.shared.habits.remove(at: index)
                self.reloadingDataDelegate?.updCollection()
                self.dismiss(animated: true, completion: nil)
            }
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

        navigBar.setItems([navigItem], animated: true)
        navigBar.backgroundColor = .systemGray
        
        if isOnEditMode == false {
            navigItem.title = "Создать"
        } else {
            navigItem.title = "Править"
        }
        
 
        view.addSubview(nameHabitLabel)
        view.addSubview(nameHabitTextField)
        view.addSubview(colorLabel)
        view.addSubview(colorPickerButton)
        view.addSubview(timeLabel)
        view.addSubview(habitTimeTextLabel)
        view.addSubview(datepicker)
        view.addSubview(datepickerLabel)
        
        
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
            habitTimeTextLabel.bottomAnchor.constraint(equalTo: datepicker.topAnchor, constant: -16),
            
            datepickerLabel.leadingAnchor.constraint(equalTo: habitTimeTextLabel.trailingAnchor, constant: .zero),
            datepickerLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            datepickerLabel.bottomAnchor.constraint(equalTo: datepicker.topAnchor, constant: -16),

            datepicker.topAnchor.constraint(equalTo: habitTimeTextLabel.bottomAnchor, constant: 15),
            datepicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datepicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        

        if isOnEditMode {
            view.addSubview(deleteHabitButton)
            
            let constrForButton = [

                deleteHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                deleteHabitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ]
            NSLayoutConstraint.activate(constrForButton)
            }
    }
}


extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        colorPickerButton.backgroundColor = selectedColor
    }
}
