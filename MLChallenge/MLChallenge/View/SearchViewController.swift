//
//  SearchViewController.swift
//  MLChallenge
//
//  Created by Gabriel Marinho da Silva on 23/10/24.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private let headerView = CustomHeaderView()
    
    private let productsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.items = [
            UITabBarItem(title: "Home", image: nil, tag: 0),
            UITabBarItem(title: "Settings", image: nil, tag: 1)
        ]
        return tabBar
    }()
    
    private let viewModel = SearchViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        headerView.searchBar.delegate = self
        headerView.cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        
        productsTableView.dataSource = self
        productsTableView.delegate = self
        
        setupLayout()
        setupBindings()
        setupCancelButton()
    }
    
    @objc private func cartButtonTapped() {
        print("Carrinho de compras pressionado")
    }
    
    private func setupLayout() {
        view.addSubview(headerView)
        view.addSubview(productsTableView)
        view.addSubview(tabBar)
        view.addSubview(loadingIndicator)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            productsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10),
            
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        viewModel.$searchText
            .sink { [weak self] text in
                guard let self = self else { return }
                if !text.isEmpty {
                    self.headerView.welcomeLabel.isHidden = true
                    self.productsTableView.isHidden = false
                    self.loadingIndicator.startAnimating()
                    self.viewModel.searchProducts()
                } else {
                    self.headerView.welcomeLabel.isHidden = false
                    self.productsTableView.isHidden = true
                    self.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellable)

        viewModel.$products
            .sink { [weak self] products in
                guard let self = self else { return }
                print("Products received: \(products.count)")
                self.productsTableView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
            .store(in: &cancellable)

        viewModel.$isLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.updateLoadingIndicator(isLoading: isLoading)
            }
            .store(in: &cancellable)
    }
    
    private func setupCancelButton() {
        if let cancelButton = headerView.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Cancelar", for: .normal)
            cancelButton.setTitleColor(.black, for: .normal)
            cancelButton.setTitleColor(.gray, for: .highlighted)
        }
    }
    
    private func updateLoadingIndicator(isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.products.count else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        let product = viewModel.products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedProduct = viewModel.products[indexPath.row]
        let detailViewController = ProductDetailViewController()
        detailViewController.product = selectedProduct
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        // Verifica se está perto do final da tabela
        if offsetY > contentHeight - scrollView.frame.size.height - 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.viewModel.fetchMoreProducts()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        setupCancelButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        headerView.welcomeLabel.isHidden = false
        productsTableView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}


