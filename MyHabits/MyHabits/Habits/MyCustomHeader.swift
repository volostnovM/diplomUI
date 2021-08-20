//
//  MyCustomHeader.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

class MyCustomHeader: UITableViewHeaderFooterView {

    var title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {

        contentView.addSubview(title)

        NSLayoutConstraint.activate([
        
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                   constant: 14),
            title.trailingAnchor.constraint(equalTo:
                   contentView.trailingAnchor),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
