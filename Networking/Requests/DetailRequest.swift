//
//  DetailRequest.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 22.02.2026.
//

import Foundation

struct DetailRequest: APIRequest {

    typealias Response = ProductDetailResponse

    var headers: [String: String]?
    let baseUrl: URL = Environment.rootURL
    let method: HTTPMethodType = .get
    var path: String {
        "product"
    }
    let queryParameters: [URLQueryItem]

    init(id: Int) {
        queryParameters = [URLQueryItem(name: "productId",
                                        value: "\(id)")]
    }
}
