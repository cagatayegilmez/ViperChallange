//
//  ListProduct.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 22.02.2026.
//

import Foundation

struct ListProduct: Decodable {

    let id: Int
    let title: String
    let image: String
    let price: Double
    let instantDiscountPrice: Double
    let rate: Double
    let sellerName: String

    var imageUrl: URL? {
        guard let url = URL(string: image) else {
            return URL(string: "https://picsum.photos/id/0/5000/3333")
        }

        return url
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
