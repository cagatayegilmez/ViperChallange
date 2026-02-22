//
//  ListingRequest.swift
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
        "listing/"
    }

    init(page: Int) {
        path += "\(page)"
    }
}
