//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 13.08.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    var detailsHabit: Habit?
    
    private let cellID = "cellID"
    
    lazy var habitTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = detailsHabit?.name
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(editTap))
        setupView()
        navigationController?.navigationBar.isHidden = false
        habitTableView.dataSource = self
        habitTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    

    @objc func editTap(){
        let habitVC = HabitViewController()
        habitVC.editingHabit = detailsHabit
        habitVC.isOnEditMode = true
        habitVC.setupEditingMode()
        
        navigationController?.present(habitVC, animated: true, completion: nil)
    }
}

extension HabitDetailsViewController{
    func setupView() {
    
        view.addSubview(habitTableView)
        let constraints = [
            habitTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        
        if let habit = detailsHabit {
            if HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[indexPath.row]) {
                cell.accessoryType = .checkmark
                cell.tintColor = .CustomPurple
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        habitTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }

}

extension HabitDetailsViewController: ReloadingTitleDelegate {
    func reloadTitle() {
        if let habit = detailsHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
            title = HabitsStore.shared.habits[index].name
        }
    }
}
