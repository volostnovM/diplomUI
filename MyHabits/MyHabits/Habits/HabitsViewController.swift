//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

class HabitsViewController: UIViewController {
    
    private lazy var store = HabitsStore.shared
    
    lazy var habitsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(HabbitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabbitCollectionViewCell.self))
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EmptyCollectionViewCell.self))
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.sizeToFit()
        button.imageView?.tintColor = .CustomPurple
        button.addTarget(self, action: #selector(addHabit), for: .touchUpInside)
        return button
    } ()
    
    lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Сегодня"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        view.addSubview(habitsCollectionView)
        view.addSubview(todayLabel)
        view.addSubview(addButton)
        setupView()
        
        navigationController?.navigationBar.isHidden = true
        habitsCollectionView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        habitsCollectionView.reloadData()
    }
    
    @objc func addHabit(sender: UIButton!) {
       print("Button tapped")
        let addHabitVC = HabitViewController()
        self.present(addHabitVC, animated: true, completion: nil)
    }
}


extension HabitsViewController {
    func setupView() {
        habitsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        habitsCollectionView.backgroundColor = .AlmostWhite
        
        let constraints = [
            
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: todayLabel.topAnchor, constant: -4),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            
            todayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 14),
            todayLabel.bottomAnchor.constraint(equalTo: habitsCollectionView.topAnchor, constant: -8),
            
            habitsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 22, left: 16, bottom: 18, right: 16)
        }
        else {
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: (habitsCollectionView.frame.width - 32), height: 60)
        } else
        {
            return CGSize(width: (habitsCollectionView.frame.width - 32), height: 130)
        }
    }
}

extension HabitsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return store.habits.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if store.habits.count != 0 {
            if indexPath.section == 0{
                let cellProgress = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell

                 return cellProgress
            } else {
                let cellHabit = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabbitCollectionViewCell.self), for: indexPath) as! HabbitCollectionViewCell

                let habit = store.habits[indexPath.item]

                if habit.isAlreadyTakenToday {
                    cellHabit.changeButton.backgroundColor = habit.color
                    print(habit.color)
                } else {
                    cellHabit.changeButton.backgroundColor = .white
                }
                 
                 cellHabit.nameHabitLabel.text = habit.name
                 cellHabit.nameHabitLabel.textColor = habit.color
                 cellHabit.dateLabel.text = habit.dateString
                 cellHabit.counterLabel.text = "Подряд: \(habit.trackDates.count)"

                 return cellHabit
            }
        } else
        {
            let cellHabit = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EmptyCollectionViewCell.self), for: indexPath) as! EmptyCollectionViewCell
            
            return cellHabit
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        habitsCollectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let habit = store.habits[indexPath.item]
            let habitDetailVC = HabitDetailsViewController()
            habitDetailVC.title = habit.name
            navigationController?.pushViewController(habitDetailVC, animated: true)
        }
    }
}
