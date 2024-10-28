//
//  SearchViewModel.swift
//  MLChallenge
//
//  Created by Gabriel on 24/10/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var products = [Product]()
    @Published var isLoading = false
    
    private var apiService = APIService()
    private var cancellable = Set<AnyCancellable>()
    
    private var currentOffset = 0
    private let limit = 10
    
    var noProductsFound: Bool {
        return !isLoading && products.isEmpty
    }
    
    var isSearchTextEmpty: Bool {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func searchProducts() {
        guard !isSearchTextEmpty else { return }
        isLoading = true
        
        products.removeAll()
        currentOffset = 0
        
        fetchProducts(offset: currentOffset) // Busca produtos com offset inicial
    }
    
    func fetchMoreProducts() {
        guard !isLoading else { return }
        fetchProducts(offset: currentOffset)
    }
    
    private func fetchProducts(offset: Int) {
        isLoading = true
        apiService.fetchProducts(query: searchText, limit: limit, offset: offset)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .failure(let error):
                    if let apiError = error as? APIError { // Resolver Warning
                        ErrorHandler.shared.handle(apiError.errorScreen)
                    } else {
                        ErrorHandler.shared.handle(ErrorScreen.data("Erro desconhecido."))
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.products.append(contentsOf: response.results) // Adiciona novos produtos à lista
                self.currentOffset += self.limit // Atualiza o offset para a próxima busca
                ErrorHandler.shared.clearError()
            }
            .store(in: &cancellable)
    }
}
