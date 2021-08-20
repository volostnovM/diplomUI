//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 13.08.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    lazy var habitTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(editTap))
        setupView()
        navigationController?.navigationBar.isHidden = false
        habitTableView.dataSource = self
    }
    

    @objc func editTap(){
        let habitVC = HabitViewController()
        habitVC.currentLastVC = .editHabit
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

        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
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
    

}
