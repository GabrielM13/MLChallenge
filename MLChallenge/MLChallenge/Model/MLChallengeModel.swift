//
//  MLChallengeModel.swift
//  MLChallenge
//
//  Created by Gabriel on 24/10/24.
//

struct Product: Identifiable, Codable {
    let id: String
    let title: String
    let thumbnail: String
    let condition: String
    let price: Double
    let available_quantity: Int
    let seller: Seller
    let currency_id: String
    let permalink: String 

    struct Seller: Codable {
        let id: Int
        let nickname: String
    }
}

struct SearchItems: Codable {
    let paging: Paging
    let results: [Product]

    struct Paging: Codable {
        let total: Int
        let offset: Int
        let limit: Int
    }
}

