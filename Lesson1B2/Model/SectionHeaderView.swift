//
//  SectionHeaderView.swift
//  Lesson1B2
//
//  Created by user on 22.04.2021.
//

import UIKit

class SectionHeaderView: UIView {
    
    let letter = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        addSubview(letter)
        letter.translatesAutoresizingMaskIntoConstraints = false
        letter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        letter.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        letter.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backgroundColor = #colorLiteral(red: 0.7339813113, green: 0.8357322812, blue: 0.9017627835, alpha: 1)
    }
}


