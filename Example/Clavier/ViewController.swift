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

    lazy var coloredView1: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "coloredView1"
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var coloredView2: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray.withAlphaComponent(0.75)
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
        coloredView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coloredView1)
        NSLayoutConstraint.activate([
            coloredView1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 48),
            coloredView1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48),
            coloredView1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coloredView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        coloredView2.translatesAutoresizingMaskIntoConstraints = false
        coloredView1.addSubview(coloredView2)
        NSLayoutConstraint.activate([
            coloredView2.leftAnchor.constraint(equalTo: coloredView1.leftAnchor),
            coloredView2.rightAnchor.constraint(equalTo: coloredView1.rightAnchor),
            coloredView2.bottomAnchor.constraint(equalTo: coloredView1.keyboardLayoutGuide.topAnchor),
            coloredView2.heightAnchor.constraint(equalTo: coloredView1.heightAnchor, multiplier: 0.25)
        ])
        clavierButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clavierButton)
        NSLayoutConstraint.activate([
            clavierButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            clavierButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            clavierButton.bottomAnchor.constraint(equalTo: view.safeKeyboardLayoutGuide.topAnchor),
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

