//
//  HabbitCollectionViewCell.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

class HabbitCollectionViewCell: UICollectionViewCell {
    
    var habit = Habit(name: "Выпить стакан воды перед завтраком", date: Date(), color: .systemRed)
        
    var nameHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .HeadLine
        label.numberOfLines = 2
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .FootNote
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
    }()
    
    var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Caption
        label.text = "Подряд: "
        label.textColor = .systemGray
        return label
    }()
    
    var changeButton: UIButton = {
        let button = UIButton()
        button.roundCornerWithRadius(19, top: true, bottom: true, shadowEnabled: false)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.borderWidth = 2
       
        return button
    }()
    
    @objc func tapButton() {
        print("press button change")
        
        if habit.isAlreadyTakenToday {
            print("Привычка уже была сегодня нажата")
        } else {
            HabitsStore.shared.track(habit)
            changeButton.backgroundColor = habit.color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.roundCornerWithRadius(6, top: true, bottom: true, shadowEnabled: false)
        contentView.backgroundColor = .white
        setupViews()
        
        changeButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
}

extension HabbitCollectionViewCell{
    private func setupViews() {
        contentView.addSubview(nameHabitLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(changeButton)
        
        
        let constraints = [
            nameHabitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: nameHabitLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.bottomAnchor.constraint(equalTo: counterLabel.topAnchor, constant: -30),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            changeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            changeButton.heightAnchor.constraint(equalToConstant: 38),
            changeButton.widthAnchor.constraint(equalToConstant: 38),
            changeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
