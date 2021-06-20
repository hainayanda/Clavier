//
//  ViewController.swift
//  Clavier
//
//  Created by 24823437 on 06/20/2021.
//  Copyright (c) 2021 24823437. All rights reserved.
//

import UIKit
import Clavier

class ViewController: UIViewController {

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "text here"
        return textField
    }()
    
    lazy var clavierButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clavier", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(clavierButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clavierButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clavierButton)
        NSLayoutConstraint.activate([
            clavierButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            clavierButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            clavierButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            clavierButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            textField.bottomAnchor.constraint(lessThanOrEqualTo: clavierButton.topAnchor, constant: -24),
            textField.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    @objc func clavierButtonTapped() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            textField.becomeFirstResponder()
        }
    }

}

