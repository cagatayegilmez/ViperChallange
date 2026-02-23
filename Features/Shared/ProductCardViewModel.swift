//
//  ProductCardViewModel.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import Foundation

struct ProductCardViewModel: Identifiable, Hashable {

    let id: Int
    let title: String
    let imageURL: URL?
    let priceText: String
    let discountedPriceText: String
    let discountText: String
    let rateText: String
    let sellerName: String?
}
