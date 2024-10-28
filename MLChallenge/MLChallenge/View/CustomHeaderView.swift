//
//  CustomHeaderView.swift
//  MLChallenge
//
//  Created by Gabriel on 28/10/24.
//

import UIKit

class CustomHeaderView: UIView {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Buscar no Mercado Livre"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .white
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        
        return searchBar
    }()
    
    let cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Olá, realize uma busca."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(searchBar)
        addSubview(welcomeLabel)
        addSubview(cartButton)
        
        NSLayoutConstraint.activate([
            // Constraints da searchBar
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            // Constraints do botão de carrinho
            cartButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cartButton.widthAnchor.constraint(equalToConstant: 24),
            cartButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Constraints da welcomeLabel
            welcomeLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

