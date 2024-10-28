//
//  ProductCell.swift
//  MLChallenge
//
//  Created by Gabriel on 25/10/24.
//

import UIKit

class ProductCell: UITableViewCell {
    static let identifier = "ProductCell"

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(productPriceLabel)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),

            productTitleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            productTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            productPriceLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 5),
            productPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with product: Product) {
        productTitleLabel.text = product.title
        productPriceLabel.text = "$\(product.price)"
        
        // Gerenciamento da imagem
        if let url = URL(string: product.thumbnail) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.productImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
