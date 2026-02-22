//
//  DetailRequest.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 22.02.2026.
//

struct ListingRequest: APIRequest {

    typealias Response = ProductListResponse

    var headers: [String: String]?
    let baseUrl: URL = Environment.rootURL
    let method: HTTPMethodType = .get
    var path: String {
        "product"
    }
    var queryParameters: [URLQueryItem] = []

    init(id: Int) {
        queryParameters = [URLQueryItem(name: "productId",
                                        value: id)]
    }
}
