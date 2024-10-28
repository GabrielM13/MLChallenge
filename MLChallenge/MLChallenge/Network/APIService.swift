//
//  APIService.swift
//  MLChallenge
//
//  Created by Gabriel on 24/10/24.
//

import Foundation
import Combine

// MARK: - API Service

class APIService {
    private let baseURL = "https://api.mercadolibre.com"
    
    func fetchProducts(query: String, limit: Int, offset: Int = 0) -> AnyPublisher<SearchItems, APIError> {
        // Gera a URL com a query, limite e offset
        let urlString = "\(baseURL)/sites/MLA/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=\(limit)&offset=\(offset)"
        
        // Verifica se a URL é válida
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.network("URL inválida.")).eraseToAnyPublisher()
        }
        
        // Faz a requisição e decodifica a resposta
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SearchItems.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                // Mapeia o erro retornado para um erro do tipo APIError
                if let urlError = error as? URLError {
                    return APIError.network(urlError.localizedDescription)
                } else {
                    return APIError.data("Erro ao decodificar os dados.")
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - APIError

enum APIError: Error {
    case network(String)
    case data(String)

    var errorScreen: ErrorScreen {
        switch self {
        case .network(let message):
            return .network(message)
        case .data(let message):
            return .data(message)
        }
    }
}


