//
//  HabbitCollectionViewCell.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

protocol ReloadingProgressBarDelegate: AnyObject {
    func reloadProgressBar()
}

class HabbitCollectionViewCell: UICollectionViewCell {
    
    weak var onTapTrackImageViewDelegate: ReloadingProgressBarDelegate?
    
    var habit: Habit? {
        didSet{
            guard let habit = habit else { return }
            nameHabitLabel.text = habit.name
            dateLabel.text = habit.dateString
            changeButton.layer.borderColor = habit.color.cgColor
            changeButton.backgroundColor = habit.color
            nameHabitLabel.textColor = habit.color
            counterLabel.text = ("Подряд: \(habit.trackDates.count)")
            
            if habit.isAlreadyTakenToday == false {
                changeButton.backgroundColor = .white
                checkMarkLabel.removeFromSuperview()
            }
        }
    }
        
    weak var delegateHabitCell: ReloadingCollectionDataDelegate?
    
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
    
    var changeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.roundCornerWithRadius(19, top: true, bottom: true, shadowEnabled: false)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.borderWidth = 3
       
        return imageView
    }()
    
    var checkMarkLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        return imageView
    }()
    
    @objc func tapButton() {
        if let checkHabit = habit {
            if checkHabit.isAlreadyTakenToday == true {
                print("Привычка уже была сегодня нажата")
            } else {
                print("трекаем время привычки")
                HabitsStore.shared.track(checkHabit)
                changeButton.backgroundColor = nameHabitLabel.textColor
                onTapTrackImageViewDelegate?.reloadProgressBar()
            }
        }
        else {
            print("Упс, вместо привычки nil")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.roundCornerWithRadius(6, top: true, bottom: true, shadowEnabled: false)
        contentView.backgroundColor = .white
        setupViews()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapButton))
        changeButton.isUserInteractionEnabled = true
        changeButton.addGestureRecognizer(tapGestureRecognizer)
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
        contentView.addSubview(checkMarkLabel)
        
        
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
            changeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46),
            
            checkMarkLabel.centerXAnchor.constraint(equalTo: changeButton.centerXAnchor),
            checkMarkLabel.centerYAnchor.constraint(equalTo: changeButton.centerYAnchor),
            checkMarkLabel.heightAnchor.constraint(equalToConstant: 25),
            checkMarkLabel.widthAnchor.constraint(equalToConstant: 25)

        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
