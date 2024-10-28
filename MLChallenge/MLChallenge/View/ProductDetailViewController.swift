//
//  ProductDetailViewController.swift
//  MLChallenge
//
//  Created by Gabriel on 25/10/24.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var product: Product?

    // Labels e ImageView
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sellerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let availableQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupLayout()
        setupView()
    }

    private func setupLayout() {
        view.addSubview(thumbnailImageView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(conditionLabel)
        view.addSubview(sellerLabel)
        view.addSubview(availableQuantityLabel)

        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            thumbnailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            conditionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            conditionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            conditionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            sellerLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 10),
            sellerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sellerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            availableQuantityLabel.topAnchor.constraint(equalTo: sellerLabel.bottomAnchor, constant: 10),
            availableQuantityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            availableQuantityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func setupView() {
        guard let product = product else { return }
        titleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        conditionLabel.text = "Condition: \(product.condition)"
        sellerLabel.text = "Seller: \(product.seller.nickname)"
        availableQuantityLabel.text = "Available: \(product.available_quantity)"

        // Carregar a imagem do produto
        if let url = URL(string: product.thumbnail) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}


