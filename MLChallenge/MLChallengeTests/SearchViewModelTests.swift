//
//  SearchViewModelTests.swift
//  MLChallenge
//
//  Created by Gabriel on 28/10/24.
//

import XCTest
import Combine
@testable import MLChallenge

class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSearchTextEmpty() {
        viewModel.searchText = " "
        XCTAssertTrue(viewModel.isSearchTextEmpty)
    }
    
    func testSearchTextNotEmpty() {
        viewModel.searchText = "Test Product"
        XCTAssertFalse(viewModel.isSearchTextEmpty)
    }
    
    func testSearchProductsWhenSearchTextIsEmpty() {
        viewModel.searchText = " "
        viewModel.searchProducts()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.products.count, 0)
    }
    
    func testNoProductsFound() {
        viewModel.products = []
        viewModel.isLoading = false
        
        XCTAssertTrue(viewModel.noProductsFound)
    }
    
    func testNoProductsFoundWhenLoading() {
        viewModel.products = []
        viewModel.isLoading = true
        
        XCTAssertFalse(viewModel.noProductsFound)
    }
    
}

