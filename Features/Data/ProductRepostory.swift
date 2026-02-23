//
//  ProductRepostory.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

final class ProductRepostory: ProductRepostoryProtocol {

    private let apiService: ServiceLayer

    init(apiService: ServiceLayer) {
        self.apiService = apiService
    }

    func fetchListing(page: Int) async throws -> ProductListResponse {
        try await apiService.send(request: ListingRequest(page: page))
    }

    func fetchDetail(productId: Int) async throws -> ProductDetailResponse {
        try await apiService.send(request: DetailRequest(id: productId))
    }
}
