//
//  ProductDetailResponse.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 22.02.2026.
//

import Foundation

struct ProductDetailResponse: Decodable {

    let title: String
    let description: String
    let images: [String]
    let price: Double
    let instantDiscountPrice: Double
    let rate: Double
    let sellerName: String

    var imageUrls: [URL] {
        images.compactMap {
            URL(string: $0)
        }
    }

    var discountPercent: Int {
        guard price > 0 else {
            return 0
        }

        let discountAmount = price - instantDiscountPrice
        let percentage = (discountAmount / price) * 100
        return Int(percentage.rounded())
    }
}
