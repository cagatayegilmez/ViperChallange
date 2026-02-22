//
//  ProductDetailResponse.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 22.02.2026.
//

struct ProductDetailResponse: Decodable {

    let title: String
    let description: String
    let images: [String]
    let price: Double
    let instantDiscountPrice: Double
    let rate: Double
    let sellerName: String

    var imageUrls: [URL] {
        let response: [URL] = []
        images.forEach { image in
            response.append(URL(string: image)
                            ?? URL(string: "https://picsum.photos/id/0/5000/3333"))
        }
        return response
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
