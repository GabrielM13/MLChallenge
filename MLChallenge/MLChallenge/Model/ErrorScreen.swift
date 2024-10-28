//
//  ErrorScreen.swift
//  MLChallenge
//
//  Created by Gabriel on 24/10/24.
//

import Foundation
import os
import UIKit

// MARK: - Error Handling

enum ErrorScreen: Error {
    case network(String)
    case data(String)
    
    var localizedDescription: String {
        switch self {
        case .network(let message): return "Erro de conexão: \(message)"
        case .data(let message): return "Erro de dados: \(message)"
        }
    }
    
    var imageName: String {
        switch self {
        case .network: return "wifi.slash"
        case .data: return "exclamationmark.magnifyingglass"
        }
    }
}

final class ErrorHandler {
    static let shared = ErrorHandler()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ErrorHandler")
    
    var currentError: ErrorScreen?
    
    func handle(_ error: Error) {
        logger.error("\(error.localizedDescription)")
        
        if let errorScreen = error as? ErrorScreen {
            DispatchQueue.main.async {
                self.currentError = errorScreen
                self.showErrorAlert(errorScreen)
            }
        } else {
            logger.fault("Erro: \(error)")
        }
    }
    
    func clearError() {
        currentError = nil
    }
    
    private func showErrorAlert(_ error: ErrorScreen) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Apresentar o alerta a partir do rootViewController
        rootViewController.present(alert, animated: true)
    }
}
